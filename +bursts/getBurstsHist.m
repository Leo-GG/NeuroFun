function [Burst SpikeBurstNumber burst_th]=getBursts(Spike)
% Burst detection, method described in Bakkum et al. (2014),  
%doi: 10.3389/fncom.2013.00193

    %% Set default parameters
    if ~exist('params','var')
        warning('No parameters given, using default values');
        % Recording parameters
        % Range of N for ISI_N histograms.
        params.nRange = [5:12]; 
        % Time steps for the ISI_N histograms, in seconds!
        params.steps = 10.^[-5:.05:3];
        params.Fs=20000;
        params.minIBI = 0.1; % bursts are merged if their IBI is smaller 
                             % than this (in s)
        params.minDuration = 0.1; % Threshold to discard short bursts (s)
        params.minNumSpikes = max(unique(Spike.C))/2; % Threshold to discard bursts with few spikes 
    end
    
    % Merge bursts under 800ms
    minIBI = 0.8; % Threshold to merge bursts

    % Parameters to discard short/scarce bursts
    minDuration = 0.05; % Threshold to discard short bursts (s)
    minNumSpikes = 20; % Threshold to discard bursts with few spikes 
    
    %% ISI Probability histograms
    % Probability histogram
    ISIP = input.HistogramISIn( Spike.T, params.nRange, params.steps );
    % Find threshold to identify bursting regime, using N=10 (change value
    % if histogram does not look right).
    [peak loc]=findpeaks(1-ISIP(8,:));
    % See if the regimes are separated by a minima with diff in p>0.02
    step=peak(length(peak)-1)-min(1-ISIP(8,:))
    if (step>0.002)
        burst_th=params.steps(loc(length(loc)-1)) % threshold in seconds
    else
        burst_th=params.steps(1)
    end
    
    %% Burst detection
    N=params.nRange(8); % N=10
    ISI_N=burst_th;
    [Burst SpikeBurstNumber] = BurstDetectISIn( Spike, N, ISI_N);

    
    
    %% Merge Burst
    disp('Merging and discarding bursts')
    % Merge bursts under params.minIBI & discard short/scarce bursts
    % according to params

    mergedBurst=[];
    mergedBurst.length=[];
    mergedBurst.T_start=[];
    mergedBurst.T_end=[];
    skip=1;
    numBurst=0;
    [sortedT orderT]=sort(Spike.T);
    
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
            while (( Burst.T_start(j)-mergeEnd )<params.minIBI  | (Burst.T_end(i)>=Burst.T_end(j)) )
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
        mergedSpikes = [min(find(Spike.T(orderT)>=mergeStart)):max(find(Spike.T(orderT)<=mergeEnd))];
        
        % Assign merged burst information, ignore bursts not meeting the
        % duration and or number of spikes requirement
        if ( mergedLength>= params.minDuration &...
                length(mergedSpikes)>=params.minNumSpikes) 
            numBurst=numBurst+1;
            SpikeBurstNumber(mergedSpikes)=numBurst;
            mergedBurst.length=[mergedBurst.length mergedLength];
            mergedBurst.T_start=[mergedBurst.T_start mergeStart];
            mergedBurst.T_end=[mergedBurst.T_end mergeEnd];
           % mergedBurst.Spikes=[mergedBurst.Spikes mergedSpikes];
        else
           % SpikeBurstNumber(mergedSpikes)=-1;
        end
        
    end
    SpikeBurstNumber=SpikeBurstNumber(orderT);
    initBurst=Burst;
    Burst=mergedBurst;
 
 
    
    %% Plot results
    figure, hold on
    set(gca,'FontSize',30);
    %
    % % Order y-axis channels by firing rates
    tmp = zeros( 1, max(Spike.C)-min(Spike.C) );
    for c = min(Spike.C):max(Spike.C)
        tmp(c-min(Spike.C)+1) = length( find(Spike.C==c) );
    end
    [tmp ID] = sort(tmp);
    OrderedChannels = zeros( 1, max(Spike.C)-min(Spike.C) );
    for c = min(Spike.C):max(Spike.C)
        OrderedChannels(c-min(Spike.C)+1) = find( ID==c-min(Spike.C)+1 );
    end
    % "
    % % Raster plot
    %plot( Spike.T(SpikeBurstNumber<0), OrderedChannels(Spike.C(SpikeBurstNumber<0)), 'k.' )
    plot( Spike.T, OrderedChannels(Spike.C), 'k.' )
    set( gca, 'ytick', (min(Spike.C):max(Spike.C))+1, 'yticklabel', ...
    ID-min(ID)+min(Spike.C) ) % set yaxis to channel ID
    %
    % % Plot times when bursts were detected
    ID = find(Burst.T_end<max(Spike.T));
    Detected = [];
    for i=ID
        Detected = [ Detected Burst.T_start(i) Burst.T_end(i) NaN ];
    end
    plot( Detected, (max(Spike.C)+30)*ones(size(Detected)), 'r', 'linewidth', 40 )
    %
    xlabel 'Time [sec]'
    ylabel 'Unit'
    legend('Spike Times','Bursts');
    
end
