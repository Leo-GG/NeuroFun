function [selUnits,result] = selectUnits(paths,params)
% Compute the number of RPVs and the estimated percentage of missing spikes
% on units detected using MySort
%
% Input:
%   - paths : structure containing the path to MySort results and to
%   workdir
%   - params : structure containing sampling rate and threshold values for
%   unit selection (% of RPVs and % of estimated missing spikes)
%
    %% Initialize MySort variables and selection criteria

    if ~exist('params','var')
        warning('No parameters given, using default values');   
        params.Fs=20000; 
        params.RPV_th=5; % Percentage of refractory period (3ms) violations
        params.missing_th=10; % Percentage of estimated missing
        params.dev_th=10; % Percentage of spikes not included in the mu +/- 3 sigma
        params.firingR_th=0.5; % Firing rate
    end
  
    %% Compute the quality measures (RPVs, estim % missing spikes, % deviation from normal dist)
    load(paths.result);
    try  % Load data if it exists
        load( [paths.work '/RPVsDist'] );
        load( [paths.work '/EstMissingDist'] );
        load( [ paths.work '/EstDevNorm']  );
        load( [ paths.work '/unitFR']  );
    catch
        % RPVs (below 3ms, in number of samples)
        pRPVs=input.getRPVs(result,params.Fs,params.Fs*3/1000);
        % Estimated missing spikes (based on the MySort detection, using
        % 3.5 std)
        [devNorm,pMissing]=input.getUndetected(result,4.2);
        % Get firing rates
        firingR=ana.garmagal.getFR(result,params.Fs);
        save( [ paths.work '/RPVsDist'] , 'pRPVs' , '-v7.3' );
        save( [ paths.work '/EstMissingDist']   , 'pMissing'   , '-v7.3' );
        save( [ paths.work '/EstDevNorm']   , 'devNorm'   , '-v7.3' );
        save( [ paths.work '/unitFR']   , 'firingR'   , '-v7.3' );
    end
    
    
    %% Select units based on quality measures
    n_units=unique(result.gdf_merged(:,1));
    selIdx=find((pRPVs<params.RPV_th & pMissing<params.missing_th & ...
        devNorm<params.dev_th & firingR>params.firingR_th));
    selUnits=n_units(selIdx);

end
