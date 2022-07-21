tags_singulated = zeros(n,1);

lambda = 1; % Rate of interrogator arrivals, in arrivals per second.  Interrogators arrive as a Poisson process.
p = 0.25; % Parameter of geometric random variable representing number of tag writes for each arrival.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate timestamps according to the interrogator statistics.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
small_interval = 0.0001*(1/lambda); % Small fraction of an average inter arrival time.
times = zeros(n,1);
curr_tag = 1;
curr_time = 0;
done = false;
while (~done)
    curr_time = curr_time + exprnd(1/lambda,1,1);
    num_writes = geornd(p,1,1);
    times(curr_tag:curr_tag+num_writes-1) = curr_time + ( (1:num_writes) * small_interval );
    curr_tag = curr_tag + num_writes;
    if (curr_tag > n)
        done = true;
    end
end
times = times(1:n,1); % To get rid of spilled over timestamps.
collected_times = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Repeatedly do Aloha on increasingly smaller tag populations.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time_cost = 0;
for (iter = 1:num_max_times)
    target_max_time = times(n-iter+1, 1); % Target max time you want to find.
    
    % Max time of the times you have collected so far, that is of course less than or equal to the target.
    max_time = max(collected_times(collected_times <= target_max_time));
    if (isempty(max_time)) max_time = 0; end;
    max_time_changed = true;   
    if (max_time > target_max_time) display('Error.'); return; end
    half_time = max_time; % In the first round, the new "half_time" is merely the largest time you have collected so far.
    half_time_changed = true;
    
    N = 16;
    done = false;
    if (half_time == target_max_time) % Already have the largest max time from a previous iteration.
        done = true;
    end
    while (~done)
        time_cost = time_cost + 20 + (N*113);
        
        % Get subset of tags to analyze.  These are the ones with times greater than half_time and less than or equal to target_max_time.
        if (half_time_changed)
            later_ids_indices = find((half_time < times) & (times <= target_max_time));
            later_times = times(later_ids_indices);
            num_later_ids = numel(later_ids_indices);
        end
        half_time_changed = false;

        tag_responses = ceil(rand(num_later_ids,1) * N); % Each responding tag picks a time slot from 1 to N at random.
        mask = ones(num_later_ids,1) * (1:N);
        occupancies = sum( (tag_responses * ones(1,N)) == mask, 1 ); % Each element contains the occupancies of a particular time slot.
        
        % Adjust N dynamically.
        s0 = sum(occupancies == 0);
        s1 = sum(occupancies == 1);
        s2 = sum(occupancies >= 2);
        if ((s0 == 0) & (s1 == 0)) % Don't change anything, time-wise.  Just double N.
            N = 2 * N;
        else
            E_values = [E0(:,N) E1(:,N) E2(:,N)]; % Get the E_values for the N we are using.
            len = numel(E0(:,N));
            abs_diff = abs( (ones(len,1)*[s0 s1 s2]) - E_values );
            [min_val, n_est] = min( sum(abs_diff.^2,2) );

            % If got some single time slots, that means can move forward in time.
            if (s1 > 0)
                single_time_slots = find(occupancies == 1)';
                single_tag_indices = find(ismember(tag_responses, single_time_slots)); % Find the tags that chose those single occupancy time slots.
                collected_times = union(collected_times, later_times(single_tag_indices));
                half_time = mean(later_times(single_tag_indices));
                half_time_changed = true;
                n_est = ceil(n_est / 2);
                
                if (half_time == target_max_time)
                    done = true;
                end
            end
            if     (( 1 <= n_est) & (n_est <= 9  )) N = 16;
            elseif ((10 <= n_est) & (n_est <= 27 )) N = 32;
            elseif ((28 <= n_est) & (n_est <= 56 )) N = 64;
            elseif ((57 <= n_est) & (n_est <= 129)) N = 128;
            else N = 256; 
            end
        end % if else    
    end % while (~done)

    time_cost = time_cost + 20 + (N*113); % Need an extra cycle to see that this indeed is the largest time.  
    all_time_costs(iter) = time_cost;
end % for (iter = 1:num_max_times)
