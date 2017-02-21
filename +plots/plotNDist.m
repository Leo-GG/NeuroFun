function plotNDist(data,labelT,labelX,labelY)
% Takes in a cell containing N vectors, each corresponding to a number of
% observations of the same property in different samples. It plots all the
% distributions corresponding to each of the vectores side by side 

    nSamples=size(data,2);
    figure;set(gca,'FontSize',20);

    y=[];
    x=[];
    for i=1:nSamples
        yi=data{i};        
        xi=ones(1,length(yi))*i + (-0.3 + (0.6)*rand(length(yi),1))';
        ci=i/nSamples;
        plot( xi , yi , 'o','color',[0 ci 0]);hold on    
        line([i-0.3 i+0.3 ],[mean(yi),mean(yi)],'color',[0 0 0])
    end   
    set(gca,'xtick',[1:nSamples],'xticklabel',labelX)
    title(labelT);
    ylabel(labelY);
end