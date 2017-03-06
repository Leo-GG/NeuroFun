function [ adjMatrix ] = calcHistConnect( Spike, spikesSet, corrLim, binSize )
%Compute connectivity as sum over histograms 
%   Uses the cross-correlogram method from Dayan, P & Abbott, L. F. (2001)
%   Sums the values on the histogram with lag>0 for connection A-B and the
%   values with lag<0 for connection B-A. The connectivities are divided by
%   the harmonic mean of the firing rates of A and B.

    if ~exist('corrLim')
        corrLim=0.012; % Upper and lower limit of cross-corr set to 12ms
    end
    
    if ~exist('binSize')
        binSize=0.001; % Bin sizes on the cross-correlogram
    end
    
    c = unique(Spike.C);
    nC = numel(c);
    adjMatrix=zeros(nC,nC);
    invMatrix=zeros(nC,nC);
    totalT=max(Spike.T)-min(Spike.T);
    parfor unitA=1:(nC)
        disp(['Processing channel ' num2str(unitA)])
        spikesA=spikesSet(spikesSet(:,2)==unitA,1);
        Avals=zeros(1,unitA);
        Bvals=zeros(1,unitA);
        for unitB=(unitA+1):nC
            % Cross-correlogram
            spikesB=spikesSet(spikesSet(:,2)==unitB,1);
            f1=length(spikesA)/totalT;
            f2=length(spikesB)/totalT;
            if (f1<0.5 | f2<0.5)
                Avals=[Avals 0];
                Bvals=[Bvals 0];
            else
                [y,bins,f1,f2] = correl.LIF_xcorr(spikesA,spikesB,binSize,...
                    [min(Spike.T) max(Spike.T)],corrLim);
                % Divide by the harmonic mean of the spike rates of A and B            
                meanFiringRate=2/(1/f1+1/f2);
                Aval=sum(y(ceil(length(y)/2)+1:end))...
                    /meanFiringRate;
                Bval=sum(y(1:floor(length(y)/2)))...
                    /meanFiringRate;
                %adjMatrix(unitA,unitB)=sum(y(ceil(length(y)/2)+1:end))...
                %    /meanFiringRate;
                %adjMatrix(unitB,unitA)=sum(y(1:floor(length(y)/2)))...
                %    /meanFiringRate;
                Avals=[Avals Aval];
                Bvals=[Bvals Bval];
            end
        end
        adjMatrix(unitA,:)=Avals;
        invMatrix(unitA,:)=Bvals;
    end
    adjMatrix=adjMatrix+invMatrix';

end

