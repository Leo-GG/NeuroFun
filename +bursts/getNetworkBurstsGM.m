function [Burst SpikeBurstNumber]=getNetworkBursts(Spike,params)
% Network-wide burst detection based on Gaussian kernel smoothing

    %% Set default parameters
    if  ~exist('params','var')
        warning('No parameters given, using default values');
        params.binSize = 0.2; % in s
    end
    
    %% Bin the spike times
    edges  = min(Spike.T):params.binSize:max(Spike.T); 
    binnedSpikes = histc(Spike.T,edges); 
    times = edges+params.binSize/2; % center of bins 

    %% GMM Threshold
    disp('Finding detection threshold');
    cDist=binnedSpikes-mean(binnedSpikes); % Normalize the distribution to -1:1 interval and center on 0
    normF=max(cDist);
    normDist=cDist./normF;
    %figure;hist(normDist,100)

    options = statset('MaxIter',1000);
    gm = fitgmdist(normDist,2,'Options',options); % Generate model as mixture of 2 gaussians
%     figure;
%     samples=[-1:0.01:1]';
%     norm = normpdf(samples,gm.mu(1),gm.Sigma(1));
%     plot(samples,norm,'r');
%     hold on;
%     norm = normpdf(samples,gm.mu(2),gm.Sigma(2));
%     plot(samples,norm,'g');
%     
    % Choose the threshold as mu-sigma from distribution with highest
    % values
    if (gm.mu(1)>gm.mu(2)) 
        burstTh=gm.mu(1)-gm.Sigma(1);
    else
        burstTh=gm.mu(2)-gm.Sigma(2);
    end
    burstTh=burstTh*normF+mean(binnedSpikes);
    
    % Show bins above threshold
    figure;plot(times,binnedSpikes);
    hold on;plot(times(binnedSpikes>burstTh),...
        binnedSpikes(binnedSpikes>burstTh),'o','markersize',2,'color','r');
    %% Assign bursts
    % Designate the time around the detected peak as a burst
    Burst.T_start=times(binnedSpikes>burstTh)-params.binSize/2;
    Burst.T_end=times(binnedSpikes>burstTh)+params.binSize/2;
    Burst.length=Burst.T_end-Burst.T_start;
    SpikeBurstNumber=-1*ones(length(Spike.C),1);

   
    %% Merge & discard 
    disp('Merging and discarding bursts')
    % Merge bursts under 800ms
    minIBI = 0.8; % Threshold to merge bursts

    % Parameters to discard short/scarce bursts
    minDuration = 0.1; % Threshold to discard short bursts (s)
    minNumSpikes = max(unique(Spike.C))/2; % Threshold to discard bursts with few spikes 
    
    mergedBurst=[];
    mergedBurst.length=[];
    mergedBurst.T_start=[];
    mergedBurst.T_end=[];
    skip=1;
    
    for i=1:length(Burst.T_start)
        if i<skip
            continue
        end
        mergeStart=Burst.T_start(i);
        mergeEnd=Burst.T_end(i);
        disp(['Checking burst no ' num2str(i) ' from ' num2str(length(Burst.T_start))]);
        if i<length(Burst.T_start)
            % Check next burst    
            j=i+1;               

            % While bursts are close enough, keep looking at subsequent ones
            while (( Burst.T_start(j)-mergeEnd )<minIBI  | (Burst.T_end(i)>=Burst.T_end(j)) )
            %while ( Spike.T(Burst.T_start(j))-Spike.T(Burst.T_end(i)) )<minIBI 
                mergeStart=Burst.T_start(i);
                mergeEnd=Burst.T_end(j);
                j=j+1;
                if j>length(Burst.T_start)
                    break;
                end
            end
            % Start checking on the first burst beyond the threshold on next
            % iteration
            skip=j;
        end
        % Compute length of merged burst in seconds and in number of spikes
        mergedLength = mergeEnd-mergeStart;
        mergedSpikes = [min(find(Spike.T>=mergeStart)):max(find(Spike.T<=mergeEnd))];
        
        % Assign merged burst information, ignore bursts not meeting the
        % duration and or number of spikes requirement
        if ( mergedLength>= minDuration & length(mergedSpikes)>=minNumSpikes)        
            SpikeBurstNumber(mergedSpikes)=i-1;
            mergedBurst.length=[mergedBurst.length mergedLength];
            mergedBurst.T_start=[mergedBurst.T_start mergeStart];
            mergedBurst.T_end=[mergedBurst.T_end mergeEnd];
           % mergedBurst.Spikes=[mergedBurst.Spikes mergedSpikes];
        else
            SpikeBurstNumber(mergedSpikes)=-1;
        end
        
    end

    initBurst=Burst;
    Burst=mergedBurst;
 
    
    %% Plot results   
    disp('Generating plots')
    % Order y-axis channels by firing rates
    tmp = zeros( 1, max(Spike.C)-min(Spike.C) );
    for c = min(Spike.C):max(Spike.C)
        tmp(c-min(Spike.C)+1) = length( find(Spike.C==c) );
    end
    [tmp ID] = sort(tmp);
    OrderedChannels = zeros( 1, max(Spike.C)-min(Spike.C) );
    for c = min(Spike.C):max(Spike.C)
        OrderedChannels(c-min(Spike.C)+1) = find( ID==c-min(Spike.C)+1 );
    end
    
    % Raster plot   
    figure, hold on;
    set(gca,'FontSize',20);
    plot( Spike.T, OrderedChannels(Spike.C), 'k.' )
    set( gca, 'ytick', (min(Spike.C):max(Spike.C))+1, 'yticklabel', ...
    ID-min(ID)+min(Spike.C) ); % set yaxis to channel ID   
    % Plot times when bursts were detected
    ID = find(Burst.T_end<max(Spike.T));
    Detected = [];
    for i=ID
        Detected = [ Detected Burst.T_start(i) Burst.T_end(i) NaN ];
    end
    plot( Detected, (max(Spike.C)+3)*ones(size(Detected)), 'r', 'linewidth', 4 )   
    xlabel 'Time [sec]'
    ylabel 'Unit'
    legend('Spike Times','Bursts');
    
       
end
