function Spike = getSpikesFromSorted(selUnits, result)    
% Generates a Spike structure from the output of MySort and considering
% only a subset of selected units

% Spike times from selected units, given in seconds
    Fs=20000;
    Spike.T=[];
    Spike.C=[];
    Spike.A=[];
    for i=1:length(selUnits)
        Spike.T = [Spike.T; result.gdf_merged(...
         result.gdf_merged_abs(:,1)==selUnits(i),2)./Fs]; 
        Spike.C = [Spike.C; ones(length(result.gdf_merged_abs(...
         result.gdf_merged_abs(:,1)==selUnits(i),1)),1)*i];
        Spike.A = [Spike.A; ones(length(result.gdf_merged_abs(...
         result.gdf_merged_abs(:,1)==selUnits(i),3)),1)*i];
    end
    Spike.A = Spike.A./(result.noiseStd(Spike.C))';
    
    [Spike.T order]=sort(Spike.T);
    tmp=Spike.C(order);
    Spike.C=tmp;
    tmp=Spike.A(order);
    Spike.A=tmp;
    
end
