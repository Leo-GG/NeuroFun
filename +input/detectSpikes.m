function [peaks noise waveforms]= detectSpikes(filteredData,map)
% Simple peak detection using 5.5 noise std. Noise std estimation is not
% robust, it is estimated as the channel std
    nChannels = length(filteredData(1,:));
    nSamples = length(filteredData(:,1));
    peaks=[];
    noise=zeros(nChannels,1);
    waveforms=cell(1024,1);
    for ch=1:nChannels;        
         if (map.elNo(ch)==-1) % Ignore non-routed electrodes
                 continue
         end
        noiseStd=std(filteredData(:,ch));
        [pks_, times_] = findpeaks(-filteredData(:,ch), 'MINPEAKHEIGHT', noiseStd*5.5,...
            'MINPEAKDISTANCE', 20);
        noise(ch)=noiseStd;
        % Peaks columns: Channel Time[Samples] Amplitude[noise Std]
        peaks=[peaks;horzcat(repmat(ch,length(pks_),1),times_,pks_./noiseStd)]; 
        % Store the waveform related to each peak, from -35 to +50 samples
        validTimes=times_(times_>10 & times_<(nSamples-20));
        chWaves=[];
        for i=1:length(validTimes)
            wave=filteredData(validTimes(i)-10:validTimes(i)+20,ch)./noiseStd;
            chWaves=[chWaves,wave];
        end
        waveforms{ch}=chWaves;        
    end
end
