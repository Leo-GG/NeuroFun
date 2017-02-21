function plotBursts(Spike,Burst)
% Plot raster plot of all channels ordered by firing rate.
% Original code from Bakkum et al. (2014) doi: 10.3389/fncom.2013.00193

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
    
end