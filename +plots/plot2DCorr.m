function plot2DCorr(M,labelT)

    % Remove empty (zeros) columns and rows. Will fail if number of
    % zero-filled columns and rows are not the same
    idx=find(sum(M,2)>0);
    M( ~any(M,2), : ) = [];  
    M( :, ~any(M,1) ) = [];
    
    % Plot
    figure;set(gca,'FontSize',20);
    imagesc(M);colorbar;
    title(labelT)
    xlabel('Electrode/Unit');
    ylabel('Electrode/Unit');

    set(gca,'XTick',[1:length(idx)]) 
    set(gca,'XTickLabel',idx) 
    
    set(gca,'YTick',[1:length(idx)]) 
    set(gca,'YTickLabel',idx) 
end