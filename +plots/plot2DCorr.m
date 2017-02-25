function plot2DCorr(M,labelT)

    % Plot full matrix
    figure;set(gca,'FontSize',20);
    imagesc(M);colorbar;
    title(labelT)
    xlabel('Electrode/Unit');
    ylabel('Electrode/Unit');

%     set(gca,'XTick',[1:length(idx)]) 
%     set(gca,'XTickLabel',idx) 
%     
%     set(gca,'YTick',[1:length(idx)]) 
%     set(gca,'YTickLabel',idx) 

    % Remove empty (zeros) columns and rows. Will fail if number of
    % zero-filled columns and rows are not the same
    %idx=find(sum(M,2)>0);
    %M( ~any(M,2), : ) = [];  
    %M( :, ~any(M,1) ) = [];
    idx=[];
    N=size(M,1); 
    nullE=0;
    for i=1:N%size(M,1)
        j=i-nullE;

        if sum(M(j,:)<=0)>=size(M,1)-1 & sum(M(:,j)<=0)>=size(M,1)-1
            M(j,:)=[];
            M(:,j)=[];
            N=N-1;
            nullE=nullE+1;
            %disp(['El ' num2str(i) ' is null']);
        else
            idx=[idx i];
        end
    end
    
    
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