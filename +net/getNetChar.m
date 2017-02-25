function [netChar]=getNetChar(normMat)
    % Density values to use (threshold_proportional)
    thList=[0.01:0.01:1];
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
        capMat(isnan(capMat))=0;
        if (size(capMat,1)~=size(capMat,2) | max(max(capMat))==0)
            inDeg(i,:)=-1*ones(1,length(normMat));
            outDeg(i,:)=-1*ones(1,length(normMat));
            moduleIdx=[];
            modularity(i)=-1;
            continue
        else 
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
    end
    netChar.inDeg=inDeg;
    netChar.outDeg=outDeg;
    netChar.modIdx=moduleIdx;
    netChar.mod=modularity;
end
