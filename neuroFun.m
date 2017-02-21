function cultureChar = neuroFun(Spike) 
% Use Spike structure containing spike times, channels and amplitude
% obtained from a MEA recording to compute a series of features from the
% neuronal sample
% 

    %% Basic features
    fprintf('Computing basic features\n');
    % Firing rates   
    C.fRates = basic.getFRates(Spike);
    % Amplitudes
    C.spikeAmp = basic.getAmplitudes(Spike);
    % Amplitude Std
    C.spikeStd = basic.getSpikeStd(Spike);
    
    %% Bursts
    % Bursting detection
    fprintf('Performing burst detection\n');
    [C.Burst, C.BurstAssign]=bursts.getBursts(Spike,'GM');    
    % Burst characteristics
    fprintf('Computing bursts features\n');
    [ C.burstChar ]= bursts.charBursts(Spike,C.BurstAssign,C.Burst);
    
    %% Correlations
    % Correlation using all spikes
    % Use at your risk, might take hours for long recordings!
    % fprintf('Computing Pairwise correlation using all spikes\n');
    % allSpikes = [Spike.T Spike.C];
    % C.histCorrelAll=correl.calcSpikeCorr(Spike,allSpikes,'Hist');
    % C.sttcCorrelAll=correl.calcSpikeCorr(Spike,allSpikes,'STTC');
    % Correlation using spikes in non-bursting regime
    fprintf('Computing Pairwise correlation using non-bursting spikes\n');
    nbSpikes = [Spike.T(C.BurstAssign<0) Spike.C(C.BurstAssign<0)];
    C.histCorrelNb=correl.calcSpikeCorr(Spike,nbSpikes,'Hist');
    C.sttcCorrelNb=correl.calcSpikeCorr(Spike,nbSpikes,'STTC');
    
    %% Network properties
    % Correlation-based characteristics
    fprintf('Computing Network Properties\n');
    [C.netChar]=net.getNetChar(C.histCorrelNb);
    
    cultureChar=C;
    
end