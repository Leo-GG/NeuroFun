function plotDist(V,labelT,labelX,labelY)

    figure;set(gca,'FontSize',20);

    y = [V];
    x = [(ones(1,length(V))) + (-0.3 + (0.3+0.3)*rand(length(V),1))'];
    plot( x(x<1.6) , y(x<1.6) , 'o','color',[0 0.7 0]);hold on    
    box off;set(gca,'tickdir','out');   
    line([1-0.3 1+0.3 ],[mean(V),mean(V)],'color',[0 0 0])
    set(gca,'xtick',[1],'xticklabel',labelX)
    title(labelT);
    ylabel(labelY);

end