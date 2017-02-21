
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


