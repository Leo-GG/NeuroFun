
%% Load spikes from a raw recording, as detected by the Mea1kServer
rawFile='/net/bs-filesvr02/export/group/hierlemann/recordings/Mea1k/michelef/170131/data/665/electrode_selection/Method2/000.raw.h5';
Spike=getSpikesFromRecord(rawFile);
% Get also pairwise distances
f=mea1k.file(rawFile);
dist=squareform(pdist([f.x f.y]));

%% Restrict to first two minutes 
demoSpike.C=Spike.C(Spike.T<120);
demoSpike.T=Spike.T(Spike.T<120);
demoSpike.A=Spike.A(Spike.T<120);

%% Perform full analysis
demoChar = neuroFun(demoSpike) 

%% Plot results
% 2D correlations
plots.plot2DCorr(demoChar.histCorrelNb,'Histogram-based correlation');
plots.plot2DCorr(demoChar.sttcCorrelNb,'STTC');

% Correlation vs distance
plots.plotCorrDist(demoChar.histCorrelNb,dist,...
    'Histogram-based correlation vs distance');

plots.plotCorrDist(demoChar.histCorrelNb,dist,...
    'STTC vs distance');

% Burst features
plots.plotDist(demoChar.Burst.length,'Burst lengths','Demo sample',...
'Length [s]');

plots.plotDist(demoChar.burstChar.CV_IBI(demoChar.burstChar.CV_IBI>0)...
    ,'CV of IBI per electrode','Demo Sample','CV');

% Network features
figure;plot([1:100],demoChar.netChar.mod)
set(gca,'FontSize',20);
title('Modularity');
xlabel('% of connections considered (in order of strenght)');
ylabel('Modularity');


%% Compare distributions (useful for multiple samples)
data=[];
data{1}=demoChar.burstChar.CV_IBI(demoChar.burstChar.CV_IBI>0);
data{2}=demoChar.burstChar.CV_withinBurstISI(demoChar.burstChar.CV_withinBurstISI>0);
plots.plotNDist(data,'Comparison',...
    {'CV of IBI' 'CV of ISI within Burst'},'Value');
