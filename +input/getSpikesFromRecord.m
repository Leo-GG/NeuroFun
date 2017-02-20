function Spike = getSpikesFromRecord(filePath)    
% Generates a Spike structure from the spikes stored in the raw recording,
% as detected by the Mea1KServer

    Fs=20000;

    f = mea1k.file(filePath);
    spikes = f.getSpikeTimes;

    Spike.C=double(spikes.channel+1);
    Spike.T=((single(spikes.frameno)))/Fs;
    Spike.T=Spike.T-min(Spike.T);
    Spike.A=spikes.amplitude; % does no actually work :/
    
end
