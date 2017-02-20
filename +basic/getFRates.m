function fRates=getFRates(Spike)
% Return spike rates for all the Units in the Spike structure. 
% Input contains C (channel/unit) and T (spike times in samples) fields
    for i=1:max(Spike.C)
        nSpikes(i)=sum(Spike.C==i);
    end
    tSeconds=(max(Spike.T)-min(Spike.T))/20000;
    fRates=nSpikes/tSeconds;
    figure; set(gca,'FontSize',20);
    hist(fRates,100);
    title('Firing rates');
    xlabel('Firing rate [spikes/s]');
    ylabel('Counts');
end