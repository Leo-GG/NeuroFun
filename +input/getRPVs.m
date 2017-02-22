function pRPVs=getRPVs(result,Fs,threshold) 
% This function reads results from mysort and computes for each detected
% unit the percentage of spikes which violate the refractory period given a
% threshold (in number of samples).
%
    n_units=unique(result.gdf_merged(:,1));
    RPVs=[];
    pRPVs=[];
    for i=1:length(n_units)
        unit_records=result.gdf_merged(:,1)==n_units(i);
        ISIs=diff(result.gdf_merged(unit_records,2));
        nRPVs=sum(ISIs<threshold);
        RPVs=[RPVs;nRPVs];
        pRPVs=[pRPVs;100*nRPVs/sum(unit_records)];
    end

end


