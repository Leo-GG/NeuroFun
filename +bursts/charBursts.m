function [ burstChar ] = charBursts(Spike,RawBurstNumber,Burst)
%Compute parameters to describe the bursting behaviour
%

    burstChar=[];

    %% Properties per channel/unit 
    elList=unique(Spike.C); % Index of electrodes/units
    totalT=(max(Spike.T)-min(Spike.T)); %Recording time in seconds
    
    rate=-1*ones(max(elList),1);
    duration=-1*ones(max(elList),1);
    wFRate=-1*ones(max(elList),1);
    spikesInB=-1*ones(max(elList),1);
    cvIBI=-1*ones(max(elList),1);
    cvISI=-1*ones(max(elList),1);

    for i=1:max(elList)
        disp(['Burst features done on ' num2str(100*i/max(elList)) '% of Channels '])
        % Burst rate:  bursts per minute on each electrode. 
        rate(i)=length(unique(RawBurstNumber(RawBurstNumber>0 & ...
            Spike.C==i) ) )/(totalT/60);
               
        % Burst duration: duration of each burst on each electrode.
        % Calculated as total time in bursts divided by number of bursts
        timeInBurst=0;
        % CV of IBI: std/mean of length of IBIs for each electrode
        IBI=[];
        bEndLast=max(Spike.T);
        
        % List of spikes belonging to electrode i
        elSpikes=Spike.T(Spike.C==i);
        % Burst numbers for spikes on electrode i
        burstIdx=(RawBurstNumber(Spike.C==i & RawBurstNumber>0));
        % Times of spikes in bursts
        burstSpikes=(Spike.T(Spike.C==i & RawBurstNumber>0));
        
        % Find IBIs as differences in spikes times for spikes with burst
        % index>0 and different butst index
        gaps=find(diff(burstIdx)~=0)+1;        
        IBI=burstSpikes(gaps)-burstSpikes(gaps-1);
        
        % Time in bursts is the sum of ISIs of spikes assigned to bursts
        % minus the IBIs
        timeInBurst=sum(diff(burstSpikes))-sum(IBI);

    
        
        if (timeInBurst>0 & rate(i)>0)
            duration(i)=timeInBurst/(rate(i)*(totalT/60)); % Mean[s]
        end
        
        if (IBI>0)
            cvIBI(i)=std(IBI)/mean(IBI);
        end
             
        % Within-burst firing rate: mean firing rate within all bursts for
        % each electrode
        if (timeInBurst>0 & rate(i)>0)
            wFRate(i)=length(Spike.C(Spike.C==i & RawBurstNumber>0))/timeInBurst;
        end
        % Percentage of spikes in bursts: spikes in bursts/spikes outside
        % for each electrode
        spikesInB(i)=length(Spike.C(Spike.C==i & RawBurstNumber>0))/...
            length(Spike.C(Spike.C==i));       
       
        % CV of within burst ISIs: std/mean of length of ISIs within bursts
        % for each electrode        
        % Get all ISIs and remove the ones corresponding to spikes in different bursts 
        ISI=diff(burstSpikes);
        validISI=[];
        for k=1:length(ISI)
            if isempty(find(IBI==ISI(k)))
                validISI=[validISI;ISI(k)];
            end
        end
        % Compute CV
        if (sum(ISI)>0)            
            cvISI(i)=std(validISI)/mean(validISI);
        end               
        
    end
    
    % Fraction of bursting electrodes: number of electrodes with rate>1
    % divided by total number of active electrodes
    fBursting=sum(rate>1)/length(elList);
    
    %% General (not per electrode/unit) burst properties
    
    % Burstiness Index: divide recording in 100s bins. Count spikes on each
    % bin and compute the fraction of spikes contained in the 15% of bins
    % with most spikes. This is f_15. BI=(f_15-0.15)/0.85
    BI=NaN;
    if (totalT>200)
        bins=[min(Spike.T):100:max(Spike.T)];
        [counts_ locs_]=hist(Spike.T,bins);
        f15=sum(counts_(counts_>prctile(counts_,85)))/length(Spike.T);
        BI=(f15-0.15)/0.85;
    end
    
    % IBIs
    IBIs=Burst.T_start(2:end)-Burst.T_end(1:end-1);
    IBIs=IBIs(IBIs>0);
    
    % Burst sizes in number of spikes
    burstIdx=unique(RawBurstNumber(RawBurstNumber>0));
    sSizes=zeros(length(burstIdx),1);
    for i=1:length(sSizes)
        sSizes(i)=sum(RawBurstNumber==burstIdx(i));
    end
    
    % Burst sizes in number of channels involved   
    cSizes=zeros(length(burstIdx),1);
    for i=1:length(sSizes)        
        cSizes(i)=length(unique(Spike.C(RawBurstNumber==burstIdx(i) )));
    end
        
    burstChar.BI=BI;
    burstChar.Rate=rate(rate>0);
    burstChar.Duration=duration(duration>0);
    burstChar.fBursting=fBursting;
    burstChar.withinBurstFR=wFRate(wFRate>0);
    burstChar.percentSpikesInBurst=spikesInB(spikesInB>0);
    burstChar.CV_IBI=cvIBI(rate>0);
    burstChar.CV_withinBurstISI=cvISI(rate>0);
    burstChar.IBIs=IBIs;
    burstChar.sSizes=sSizes;
    burstChar.cSizes=cSizes;
    burstChar.spikesInB=spikesInB;
    
    
end

