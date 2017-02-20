function spikeAmps = getAmplitudes(Spike)
% Return mean peak amplitude for each channel. Input contains channel
% number and amplitude for each spike
    spikeAmps = zeros(max(Spike.C),1);
    for i=1:max(SpikeRaw.C)
        iAmps=sum(Spike.A(Spike.C==i))
        spikeAmps(i)=median(iAmps);
    end    
end