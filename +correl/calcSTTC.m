function [ STTC ] = calcSTTC( spikes1,spikes2,totalT,deltaT,T1,T2 )
%
%   Spike tilling coefficient
%   STTC=1/2(P1-T2)/(1-P1*T2)+(P2-T1)/(1-P2*T1)
%   P is the proportion (fraction?) of spikes on one electrode happening 
%   within Delta t of a spike on the other one. T is the fraction of the 
%   total recording time that lies within Delta t of a spike on the 
%   electrode. 
%
%   INPUT
%   @spikes1: spikes times for unit/electrode 1
%   @spikes2: spikes times for unit/electrode 2
%   @totalT: total recording time
%   @deltaT: array of values to compute STTC
%
%   OUTPUT
%   @STTC: the spike tilling coefficient, calculated according to the
%   formula above
%
    
[r1 c1] = size(spikes1);
[r2 c2] = size(spikes2);
if r1 > c1
    spikes1 = spikes1';
end
if r2 > c2
    spikes2 = spikes2';
end

 mat1 = repmat(spikes1,length(spikes2),1);   % find difference between spike
                                             % times....
 mat2 = repmat(spikes2',1,length(spikes1));
 diffT = mat2 - mat1;                        % matrix of all time 
                                             % differences between spikes
 
 P1=sum(sum(abs(diffT)<deltaT)>0)/length(spikes1); % Proportion of spikes from 1 
                                              % within +/- Delta t of spikes
                                              % from 2
 P2=sum(sum(abs(diffT)<deltaT,2)>0)/length(spikes2);

            
% T1=(length(spikes1)*2*deltaT)/totalT;
% T2=(length(spikes2)*2*deltaT)/totalT;
STTC=0.5*( (P1-T2)/(1-P1*T2) + (P2-T1)/(1-P2*T1) );

end

