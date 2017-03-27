function spikeStd = getAmplitudes(Spike)
% Return the peak standard deviation for each channel. Input contains
% channel number and amplitude for each channel
% Amplitudes should be in number channel std, so the peak std caused by the
% cell is estimated as std(peak)-1/mean(peaks)
    
    c = unique(Spike.C);
    spikeStd = zeros(numel(c),1);
    for i=1:numel(c)
        iAmps=Spike.A(Spike.C==c(i));
        spikeStd(i)=(std(iAmps)-0.75)/median(iAmps);
        if spikeStd(i)<0
            spikeStd(i)=0;
        end
    end    
end