function [ adjMatrix ] = calcSTTCConnect( Spike, spikesSet )
%Compute connectivity matrix based on the STTC
%   Computes the STTC for each pair of elements and places the values in a
%   squared matrix. Normalization by firing rates is implicit in STTC
    
    totalT=(max(Spike.T)-min(Spike.T));
    
    c = unique(Spike.C);
    nC = numel(c);
    adjMatrix=-1*ones(nC,nC);
    deltaT=50/1000;
    
    % pre-compute T for all units/electrodes
    T=zeros(nC,1);
    for i=1:nC
        spikesC=spikesSet(spikesSet(:,2)==i,1);
        Tfull=(length(spikesC)*2*deltaT);
        ISIs=diff(spikesC);
        overlap=2*deltaT-ISIs;
        T(i)=(Tfull-sum(overlap(overlap>0)))/totalT;
    end
    
    parfor i=1:nC
        disp(['Processing channel ' num2str(i)])
        spikes1=spikesSet(spikesSet(:,2)==i,1);
        iVals=zeros(1,i);
        for j=i+1:nC
            spikes2=spikesSet(spikesSet(:,2)==j,1);
            fr1=length(spikes1)/totalT;
            fr2=length(spikes2)/totalT;
            normR=2/((1/fr1)+(1/fr2));
            if (fr1<0.5) | (fr2<0.5)
                STTC=-1;
            else
                STTC = correl.calcSTTC( spikes1,spikes2,totalT,deltaT,T(i),T(j) );
            end
            %adjMatrix(i,j)=STTC;
            %adjMatrix(j,i)=STTC;

            iVals=[iVals STTC];
        end
        if (length(iVals)==nC)
            adjMatrix(i,:)=iVals;
        end
    end
    adjMatrix=adjMatrix+adjMatrix';
    adjMatrix(isnan(adjMatrix))=0;
end

