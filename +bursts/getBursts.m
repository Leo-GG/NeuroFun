function [Burst BurstNumbers ] = getBursts(Spike,alg)
% Performs burst detection using the selected algorithm:
% 'Hist': uses the histogram-based detection method described in Bakkum et 
% al. (2014), doi: 10.3389/fncom.2013.00193
% 'MaxInt': uses the MaxInterval method as described in the NeuroExplorer
% package
% 'KS': uses a kernel to smooth binned spike frequencies. Bursts are
% detected as the peaks on the smoothed frequencies and assigned fixed
% length
% 'GM': uses a Gaussian Mixture Model to describe the distribution of spike
% frequencies assuming two distribution (burst/non-burst). The mean of the
% second distribution minus one standard deviation is taken as threshold to
% detect bursts
%
    switch alg
        case 'Hist'
            [Burst BurstNumbers ] = getBurstsHist(Spike);
        case 'MaxInt'
            [Burst BurstNumbers ] = getBurstsMaxInt(Spike);
        case 'KS'
            [Burst BurstNumbers ] = getNetworkBurstsKS(Spike);
        case 'GM'
            [Burst BurstNumbers ] = getNetworkBurstsGM(Spike);
        otherwise 
            fprintf('Invalid argument for algorithm selection\n')
    end

end
