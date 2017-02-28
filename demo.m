
%% Load spikes from a raw recording, as detected by the Mea1kServer
load('NeuroFun/demoData/demoSpike.map')
load('NeuroFun/demoData/mapP.map')
dist=mapP

%% Restrict to first 30 seconds
demoSpike.C=demoSpike.C(demoSpike.T<30);
demoSpike.T=demoSpike.T(demoSpike.T<30);
demoSpike.A=demoSpike.A(demoSpike.T<30);

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
% Enable only if BCT is installed and the calculations were run
%figure;plot([1:100],demoChar.netChar.mod)
%set(gca,'FontSize',20);
%title('Modularity');
%xlabel('% of connections considered (in order of strenght)');
%ylabel('Modularity');


%% Compare distributions (useful for multiple samples)
data=[];
data{1}=demoChar.burstChar.CV_IBI(demoChar.burstChar.CV_IBI>0);
data{2}=demoChar.burstChar.CV_withinBurstISI(demoChar.burstChar.CV_withinBurstISI>0);
plots.plotNDist(data,'Comparison',...
    {'CV of IBI' 'CV of ISI within Burst'},'Value');
