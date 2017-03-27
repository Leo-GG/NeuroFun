function skitten(xVals,yVals)
% Scatters kittens on xVals and yVals coordinates
    % load kittens
    im=[];
    for i=1:10
        im{i}=imread(['Neurofun/+plots/+kittens/k' num2str(i) '.jpg']);
    end

    % adjust kitten size relative to the graph
    size=sqrt( (max(xVals)-min(xVals))* (max(yVals)-min(yVals)))/20;

    figure;hold on;
    axis([min(xVals) max(xVals) min(yVals) max(yVals)]);    
    % one randome kitten per data point
    for i=1:length(xVals)
        kitten=im{randi(10)};
        image([xVals(i)-size/2 xVals(i)+size/2],[yVals(i)+size/2 yVals(i)-size/2],kitten);
    end
end