function [netChar]=getNetChar(normMat)
    % Density values to use (threshold_proportional)
    thList=[0.01:0.01:1];
cVals=reshape(normMat,[],1);
z=normMat;
z( ~any(z,2), : ) = [];  %rows
z( :, ~any(z,1) ) = [];  %columns
normMat=z;
    % Degree
    inDeg=zeros(length(thList),length(normMat));
    outDeg=zeros(length(thList),length(normMat));
    totalDeg=zeros(length(thList),length(normMat));

    % Modularity
    moduleIdx=zeros(length(thList),length(normMat));
    modularity=zeros(length(thList),1);

    % Calc values for each network density    
    for i=1:length(thList)
        disp(['Analyzing network using ' num2str(i) '% of connections'])
        % Reduced % of connections
        sMat=normMat./max(max(normMat));
        capMat=threshold_proportional(normMat,thList(i));  
capVals=reshape(capMat,[],1);
        %capMat(capMat>0)=1;
        % Degree
        [id,od,deg]=weightedDeg(capMat);
        inDeg(i,:)=id;
        outDeg(i,:)=od;
        totalDeg(i,:)=deg;
        % Modularity
        [Ci,Q]=modularity_dir(capMat);
        moduleIdx(i,:)=Ci;
        modularity(i)=Q;
    end
    netChar.inDeg=inDeg;
    netChar.outDeg=outDeg;
    netChar.modIdx=moduleIdx;
    netChar.mod=modularity;
end
