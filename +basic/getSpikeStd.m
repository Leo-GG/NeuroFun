function spikeStd = getAmplitudes(Spike)
% Return the peak standard deviation for each channel. Input contains
% channel number and amplitude for each channel
    spikeStd = zeros(max(Spike.C),1);
    for i=1:max(Spike.C)
        iAmps=sum(Spike.A(Spike.C==i));
        spikeStd(i)=std(iAmps);
    end    
end