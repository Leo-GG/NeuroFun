function corrMat = calcSpikeCorr(Spike,spikesSet,alg)
% Computes the correlation between spike trains using either the
% cross-correlogram method from Dayan, P & Abbott, L. F. (2001) or the
% Spike Time Tiling Coefficient from Cutts & Eglen (2014).
% The correlation is computed on a subset of spikes, indicated by the
% spikeset variable; these can be all the spikes or only the ones in the
% non-burting regime or on any given subset of the data

    switch alg
        case 'Hist'
            corrMat = calcHistConnect(Spike,spikesSet);
        case 'STTC'
            corrMat = calcSTTCConnect(Spike,spikesSet);    
        otherwise 
            fprintf('Invalid argument for algorithm selection\n')
    end

end
