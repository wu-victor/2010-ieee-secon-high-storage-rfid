tags_singulated = zeros(n,1);

%%%%%%%%%%%%%%%%%%%%%%%
% Do Aloha until done.
%%%%%%%%%%%%%%%%%%%%%%%
time_cost = 0;
N = 16;
done = false;
while (~done)
    time_cost = time_cost + 3 + (N*113);

    tag_responses = ceil(rand(n,1) * N); % Each tag picks a time slot from 1 to N at random.
    mask = ones(n,1) * (1:N);   
    occupancies = sum( (tag_responses*ones(1,N)) == mask, 1 );   
    single_time_slots = find(occupancies == 1)';
    single_tag_indices = find(ismember(tag_responses, single_time_slots)); % Find the tags that chose those single occupancy time slots.
    tags_singulated(single_tag_indices) = 1;

    % We are done when we have singulated at least 99 percent of the tag population.  Assume algorithm does this with high probability.
    % We are just simulating the time cost of it.
    if (sum(tags_singulated) >= round(0.99*n)) done = true; end 
    
    % Adjust N dynamically for the next round.
    s0 = sum(occupancies == 0);
    s1 = sum(occupancies == 1);
    s2 = sum(occupancies >= 2);       
    if ((s0 == 0) & (s1 == 0))
        N = 2 * N;
    else       
        E_values = [E0(:,N) E1(:,N) E2(:,N)]; % Get the E_values for the N we are using.
        len = numel(E0(:,N));
        abs_diff = abs( (ones(len,1)*[s0 s1 s2]) - E_values );
        [min_val, n_est] = min( sum(abs_diff.^2,2) );
        if     (( 1 <= n_est) & (n_est <= 9  )) N = 16;
        elseif ((10 <= n_est) & (n_est <= 27 )) N = 32;
        elseif ((28 <= n_est) & (n_est <= 56 )) N = 64;
        elseif ((57 <= n_est) & (n_est <= 129)) N = 128;
        else N = 256; 
        end
    end


end

