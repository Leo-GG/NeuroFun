function fRates=getFRates(Spike)
% Return spike rates for all the Units in the Spike structure. 
% Input contains C (channel/unit) and T (spike times in samples) fields
    c = unique(Spike.C);
    for i=1:numel(c)
        nSpikes(i)=sum(Spike.C==c(i));
    end
    tSeconds=(max(Spike.T)-min(Spike.T));
    fRates=(nSpikes/tSeconds)';
    figure; set(gca,'FontSize',20);
    hist(fRates,100);
    title('Firing rates');
    xlabel('Firing rate [spikes/s]');
    ylabel('Observations');
end