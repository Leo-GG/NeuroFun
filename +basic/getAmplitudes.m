function spikeAmps = getAmplitudes(Spike)
% Return mean peak amplitude for each channel. Input contains channel
% number and amplitude for each spike
    c = unique(Spike.C);    
    spikeAmps = zeros(numel(c),1);
    
    for i=1:numel(c)
        spikeAmps(i)=median(Spike.A(Spike.C==c(i)));        
    end    
end