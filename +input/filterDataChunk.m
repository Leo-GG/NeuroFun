function filteredFIR=filterDataChunk(rawFile,filter,startFrame,nSamples)                
    % Bandpass filter the signal with 2nd order Butter filter
    % 500-3000Hz, 20kHz sampling rate
    
    % Load data from file
    rawH5=mea1k.file(rawFile);
    rawH5.getH5Info();    
    rawData = rawH5.getData(startFrame,nSamples);
    % Gain used to prevent loss of precission by MySort; not relevant here
    gain=256;

    % Substract the mean of each channel
    subsMean = bsxfun(@minus, rawData, mean(rawData,1));
    clear('rawData');
    % Substract the mean across all channels
    subsMean = subsMean-repmat(mean(subsMean,2), 1, size(subsMean,2));
    % Apply filter        
    filteredFIR=conv2(subsMean,filter(:),'same');
    clear('subsMean');
    lsb=1/(2^13.8-1)/gain*1000000;
    % Apply gain
    filteredFIR=filteredFIR*gain*lsb;

end
