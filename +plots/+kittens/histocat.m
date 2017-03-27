
function histocat(bars_,locs_)
% Plot your bar graph using longcats
    longCat=imread(['Neurofun/+plots/+kittens/longCat.png']); % load cat
    xSize=locs_(2)-locs_(1); %set image width
    
    figure; hold on;
    for i=1:length(bars_)    
        image([locs_(i)-xSize/2 locs_(i)+xSize/2],[bars_(i) 0],longCat);

    end    
    ylim([0 max(bars_)+2]);
end
