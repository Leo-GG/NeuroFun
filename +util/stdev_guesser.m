% fit the standard deviation to the histogram by looking for an accurate
% match over a range of possible values
function [stdev,m] = stdev_guesser( thresh_val, n, x, m)

    % initial guess is juts the RMS of just the values below the mean
    init = sqrt( mean( (m-thresh_val(thresh_val>=m)).^2  ) );

    % try 20 values, within a factor of 2 of the initial guess
    num = 20;
    st_guesses = linspace( init/2, init*2, num );
    m_guesses  = linspace( m-init,max(m+init,1),num);
    for j = 1:length(m_guesses)
        for k = 1:length(st_guesses)
              b = normpdf(x,m_guesses(j),st_guesses(k));
              b = b *sum(n) / sum(b);
              error(j,k) = sum(abs(b(:)-n(:)));
        end        
    end
    
    % which one has the least error?
    [val,pos] = min(error(:));
    jpos = mod( pos, num ); if jpos == 0, jpos = num; end
    kpos = ceil(pos/num);
    stdev = st_guesses(kpos);
    
    % refine mode estimate
    m     = m_guesses(jpos);

end