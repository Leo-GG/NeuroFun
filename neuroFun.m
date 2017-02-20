function cultureChar = neuroFun(Spike) 
% Use Spike structure containing spike times, channels and amplitude
% obtained from a MEA recording to compute a series of features from the
% neuronal sample
% 

    %% Basic features
    % Firing rates   
    C.fRates = basic.getFRates(Spike);
    % Amplitudes
    C.spikeAmp = basic.getAmplitudes(Spike);
    % Amplitude Std
    C.spikeStd = basic.getSpikeStd(Spike);
    
    %% Bursts
    % Bursting detection
    [C.Burst C.BurstAssign]=bursts.getBursts(Spike,'GM');
    % Burst characteristics
    [ C.burstChar ]= bursts.charBursts(Spike,C.BurstNumbers);
    
    %% Correlations
    % Correlation using all spikes
    allSpikes = [Spike.T Spike.C];
    C.histCorrelAll=correl.calcSpikeCorr(Spike,allSpikes,'Hist');
    C.sttcCorrelAll=correl.calcSpikeCorr(Spike,allSpikes,'STTC');
    % Correlation using spikes in non-bursting regime
    nbSpikes = [Spike.T(C.BurstAssign<0) Spike.C(C.BurstAssign<0)];
    C.histCorrellNb=correl.calcSpikeCorr(Spike,nbSpikes,'Hist');
    C.sttcCorrellNb=correl.calcSpikeCorr(Spike,nbSpikes,'STTC');
    
    %% Network properties
    % Correlation-based characteristics
    [C.netChar]=net.getNetChar(histConnectNb);
    
    cultureChar=C;
    
end