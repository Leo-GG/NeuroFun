function spikeStd = getAmplitudes(Spike)
% Return the peak standard deviation for each channel. Input contains
% channel number and amplitude for each channel
% Amplitudes should be in number channel std, so the peak std caused by the
% cell is estimated as std(peak)-1/mean(peaks)
    spikeStd = zeros(max(Spike.C),1);
    for i=1:max(Spike.C)
        iAmps=Spike.A(Spike.C==i);
        spikeStd(i)=(std(iAmps)-0.75)/median(iAmps);
        if spikeStd(i)<0
            spikeStd(i)=0;
        end
    end    
end