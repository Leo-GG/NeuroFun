function plotDistSq(M,labelT,labelX,labelY)
    vM=reshape(M,[],1);
    V=vM(vM~=0);
    plots.plotDist(V,labelT,labelX,labelY);    

end