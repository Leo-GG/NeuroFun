
%% Load spikes from a raw recording, as detected by the Mea1kServer
rawFile='/net/bs-filesvr02/export/group/hierlemann/recordings/Mea1k/michelef/161123/data/529/electrode_selection/Method2/000.raw.h5';
Spike=getSpikesFromRecord(rawFile);
% Get also pairwise distances
f=mea1k.file(rawFile);
dist=squareform(pdist([f.x f.y]));

%% Restrict to first minute 
demoSpike.C=Spike.C(Spike.T<60);
demoSpike.T=Spike.T(Spike.T<60);
demoSpike.A=Spike.A(Spike.T<60);

%% Perform full analysis
demoChar = neuroFun(demoSpike) 


