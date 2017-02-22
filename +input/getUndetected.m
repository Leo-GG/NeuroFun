function [pval_Units,pA]=getUndetected(result,threshold)
% This function reads results from mysort and makes a histogram of peak
% amplitudes for each unit. The amplitudes are normalized by the threshold,
% which is 3.5 the noise std (different on each channel). Then it fits a
% Gaussian to the distribution and estimates the percentage of missing
% spikes as the tail of the distribution which falls below the detection
% threshold.
% This function is the same as the one in UltraMegaSort2k (UMS2K) and it 
% uses auxiliary functions from UMS2K to estimate the mean (computed as the
% mode) and the std of the distribution
% 
% Additionally, it computes the percentage of spikes within the mu+/-3sigma
% interval (ideally 0.997) and returns the deviation from the ideal case as
% a percentage.

n_units=unique(result.gdf_merged(:,1));
% constant bin count
bins = 75;
pval_Units=100.*ones(length(n_units),1);
pA=100.*ones(length(n_units),1);
for i=1:length(n_units)
    
    unit_records=result.gdf_merged(:,1)==n_units(i);
    % amplitude of each spike in noise std units, different for each
    % channel
    amplitude = double(result.gdf_merged(unit_records,3));
    channels = double(result.gdf_merged(unit_records,4));
    amplitude = amplitude./(result.noiseStd(channels))';
    
    if (sum (amplitude)==0)
        pval_Units=[pval_Units;100];
        continue;
    end
    
    % create the histogram values
    global_max = max(amplitude);
    mylims = linspace( 1,global_max,bins+1);

    x = mylims +  (mylims(2) - mylims(1))/2;
    n = histc( amplitude,mylims );
    
    % fit the histogram with a cutoff gaussian
    m = mode_guesser(amplitude, .05);    % use mode instead of mean, since tail might be cut off
    [stdev,mu] = ana.garmagal.stdev_guesser(amplitude, n, x, m); % fit the standard deviation as well

    % Now make an estimate of how many spikes are missing below the cutoff, given the Gaussian and the cutoff
    p = normcdf( threshold,mu,stdev);
    pval_Units(i) = p*100;
    
    % Estimated range of amplitudes containing 99.7% of spikes
    lowLim=mu-3*stdev;
    upLim=mu+3*stdev;
    % Spikes within range
    normSpikes=sum(amplitude>lowLim & amplitude<upLim)/length(amplitude);
    % Approximate deviation from estimated normal
    pA(i) = (0.997-normSpikes)*100;
end


end




