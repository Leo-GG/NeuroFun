function [Burst RawBurstNumber]=getBurstMaxInt(Spike)
% Detect bursts using the MaxInterval algorithm from the Neuroexplorer
% package

%% Setup
% time in Spike.T is in seconds! so are all the parameters
maxInterval = 0.01; % Threshold to detect the start of a burst
maxEndInterval = 0.025; % Threshold to detect stop of a burst
minIBI = 0.8; % Threshold to merge bursts
minDuration = 0.05; % Threshold to discard short bursts
minNumSpikes = 6; % Threshold to discard bursts with few spikes 
% Get all ISI
ISIs = diff(Spike.T);

% ISIs below threshold for burst beginning
bBeginning = find(ISIs<maxInterval);

% ISIs above threshold for burst end
bEnds = find(ISIs>maxEndInterval);

%% Burst detection
Burst.start=[];
Burst.stop=[];
Burst.length=[];
Burst.T_start=[];
Burst.T_end=[];

% Keep temp list of beginnings and ends, shorten it during burst detection
% Save CPU time
tmpBeg=bBeginning;
tmpEnd=bEnds;


while (~isempty(tmpBeg))
    % First burst
    Bstart=tmpBeg(1); 
    % Detect burst end at threshold crossing and store 
    Bstop=tmpEnd(min(find(tmpEnd>Bstart))); 

    if (isempty(Bstop))
        Bstop=length(Spike.T);
    end
    
    Blength=Bstop-Bstart; % burst length in s
    % Store the burst info
    Burst.start=[Burst.start Bstart];
    Burst.stop=[Burst.stop Bstop];
    Burst.length=[Burst.length Blength];
    Burst.T_start=[Burst.T_start Spike.T(Bstart)];
    Burst.T_end=[Burst.T_end Spike.T(Bstop)];
    
    % Shorten the lists
    tmpBeg=tmpBeg(tmpBeg>Bstop);
    tmpEnd=tmpEnd(tmpEnd>Bstop);
end

%% Merge Burst
mergedBurst.start=[];
mergedBurst.stop=[];
mergedBurst.length=[];
mergedBurst.T_start=[];
mergedBurst.T_end=[];
skip=1;

for i=1:length(Burst.start)
    if i<skip
        continue
    end
    mergeStart=Burst.start(i);
    mergeEnd=Burst.stop(i);
    if i<length(Burst.start)
        % Check next burst    
        j=i+1;               

        % While bursts are close enough, keep looking at subsequent ones
        while ( Spike.T(Burst.start(j))-mergeEnd )<minIBI 
            mergeStart=Burst.start(i);
            mergeEnd=Burst.stop(j);
            j=j+1;
            if j>length(Burst.start)
                break;
            end
        end
        % Start checking on the first burst beyond the threshold on next
        % iteration
        skip=j;
    end
    mergedLength = Spike.T(mergeEnd)-Spike.T(mergeStart);
    mergedSpikes = [mergeStart:mergeEnd];
    % Assign merged burst information, ignore bursts not meeting the
    % duration and or number of spikes requirement
    if ( mergedLength>= minDuration & length(mergedSpikes)>=minNumSpikes)        
        mergedBurst.start=[mergedBurst.start mergeStart];
        mergedBurst.stop=[mergedBurst.stop mergeEnd];
        mergedBurst.length=[mergedBurst.length mergedLength];
        mergedBurst.T_start=[mergedBurst.T_start Spike.T(mergeStart)];
        mergedBurst.T_end=[mergedBurst.T_end Spike.T(mergeEnd)];
       % mergedBurst.Spikes=[mergedBurst.Spikes mergedSpikes];
    end
end

initBurst=Burst;
Burst=mergedBurst;

%% Assign burst to each spike
RawBurstNumber=-1*ones(length(Spike.C),1);
for i=1:length(Burst.start)
    RawBurstNumber(Burst.start(1):Burst.stop(1))=i;
    
end


%% Plot results
figure, hold on
set(gca,'FontSize',20);
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
plot( Detected, (max(Spike.C)+4)*ones(size(Detected)), 'r', 'linewidth', 4 )
%

% % Plot times when bursts were detected
ID = find(initBurst.T_end<max(Spike.T));
Detected = [];
for i=ID
    Detected = [ Detected initBurst.T_start(i) initBurst.T_end(i) NaN ];
end
plot( Detected, (max(Spike.C)+1)*ones(size(Detected)), 'g', 'linewidth', 4 )
%
xlabel 'Time [sec]'
ylabel 'Unit'
legend('Spike Times','Merged Burst','Initial Burst');