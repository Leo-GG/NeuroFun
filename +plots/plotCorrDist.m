function plotCorrDist(M,dist,labelT)
    
    vM=reshape(M,[],1);
    vDist=reshape(dist,[],1);
    figure;plot(vDist(vM~=0),vM(vM~=0),'.','MarkerSize',0.5);
    set(gca,'FontSize',20);
    title('Correlation vs Electrode/Unit distance');
    xlabel('Distance [um]');
    ylabel('Correlation');
    title(labelT);

end