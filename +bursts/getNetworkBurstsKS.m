function [Burst SpikeBurstNumber]=getNetworkBursts(Spike,params)
% Network-wide burst detection based on Gaussian kernel smoothing

    %% Set default parameters
    if  ~exist('params','var')
        warning('No parameters given, using default values');
        params.binSize = 0.2; % in s
        params.sigma  = 0.2;   % kernel standard deviantions in s
        params.minBurstDist=80; % min burst separation in no of bins
    end
    
    %% Bin the spike times
    edges  = min(Spike.T):params.binSize:max(Spike.T); 
    binnedSpikes = histc(Spike.T,edges); 
    times = edges+params.binSize/2; % center of bins 

    %% Generate and apply Gaussian kernel
    kernel = normpdf(-3*params.sigma:params.binSize:3*params.sigma,...
        0,params.sigma);
    kernel = kernel*params.binSize; % integral = 1;

    % Smoothing
    firingRate = conv(binnedSpikes,kernel,'same');
    firingRate = firingRate/params.binSize;
   
    %% Burst detection
    % Detect peaks in firing rate as burst centers
    [pks,locs] = findpeaks(firingRate,'MinPeakDistance',params.minBurstDist);

    % Designate the time around the detected peak as a burst
    Burst.length=repmat(params.binSize*4,1,length(locs));
    Burst.T_start=times(locs)-params.binSize*2;
    Burst.T_end=times(locs)+params.binSize*2;    
    SpikeBurstNumber=-1*ones(length(Spike.C),1);
    for i=1:length(Burst.T_start)
        SpikeBurstNumber(Spike.T>=Burst.T_start(i) &...
            Spike.T<=Burst.T_end(i))=i;
    end
    
    %% Plot results            
    % Plot firing rates on binned time
    figure;
    plot(times,firingRate);    
    % Plot detected burst centers
    hold on;
    plot(times(locs),firingRate(locs),'ko','markersize',5,'linewidth',2);
    
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
    figure, hold on
    set(gca,'FontSize',20);
    plot( Spike.T, OrderedChannels(Spike.C), 'k.' )
    set( gca, 'ytick', (min(Spike.C):max(Spike.C))+1, 'yticklabel', ...
    ID-min(ID)+min(Spike.C) ) % set yaxis to channel ID   
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
    

%  ID = find(Burst1.T_end<max(Spike.T));
%     Detected = [];
%     for i=ID
%         Detected = [ Detected Burst1.T_start(i) Burst1.T_end(i) NaN ];
%     end
%     plot( Detected, (max(Spike.C)+6)*ones(size(Detected)), 'g', 'linewidth', 4 )   
% 
%     xlabel 'Time [sec]'
%     ylabel 'Unit'
%     legend('Spike Times','Bursts');
  
 end
