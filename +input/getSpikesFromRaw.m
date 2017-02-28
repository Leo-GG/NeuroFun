function Spike = getSpikesFromRaw(filePath)
% Generate a Spike structure from a Raw recording file
% The structure contains spike time, channel and amplitudes, sorted by the
% spike times
% The input is loaded in chunks of 10s, filtered and processed to detect
% peaks using a 5.5 std threshold

    firFilter=input.genFilter();
    Spike.T=[];
    Spike.C=[];
    Spike.A=[];
    rawFile=mea1k.file(filePath);
    rawFile.getH5Info();
    map.elNo=rawFile.electrode; % List of electrodes; non-routed=-1
    recordL=rawFile.maxSamples;
    Fs=20000;
    chunks=[1:Fs*10:recordL];
    chunkSize=20000*10;
    % Go in 10s chunks
    for i=chunks(1:end-1)
        disp(['Processing ' num2str((i+chunkSize)/20000) ' seconds'])
        %Filter raw data
        startFrame=i;
        filteredData=input.filterDataChunk(filePath,firFilter,startFrame,chunkSize-1);
        % Detect spikes. Peaks given in std units!
        % Peaks columns: Channel Time[Samples] Amplitude[channel Std]
        [peaks noiseStd chSpikes]=input.detectSpikes(filteredData,map);
        Spike.T=[Spike.T;(peaks(:,2)+(startFrame-1))./Fs];
        Spike.C=[Spike.C;peaks(:,1)];
        Spike.A=[Spike.A;peaks(:,3)];
    end
end
