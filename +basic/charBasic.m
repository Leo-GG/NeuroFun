function basicChar=charBasic(Spike)
% Runs basic analys: firing rate, spike amplitudes, spike amplitude std
    basicChar.fRates = basic.getFRates(Spike);
    basicChar.spikeAmp = basic.getAmplitudes(Spike);
    basicChar.spikeAmpStd = basic.getSpikeStd(Spike);

end