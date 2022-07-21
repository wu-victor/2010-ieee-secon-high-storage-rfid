num_bits = 96; % Number of bits in tag ID.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate tag IDs and timestamps (just strict ordering).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ids = [];
while (numel(ids) < n)
    id = ceil(rand()*2^num_bits); id(id==0) = 1;
    id = id - 1;
    if (~ismember(id,ids))
        ids(end+1) = id;
    end
end
ids_bin = dec2bin(ids, num_bits) == '1';

times = randperm(n)';
collected_times = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do modified query tree.
%%%%%%%%%%%%%%%%%%%%%%%%%%
time_cost = 0;
for (iter = 1:num_max_times)

    target_max_time = n-iter+1; % Target max time you want to find.
    
    max_time = max(collected_times(collected_times <= target_max_time));
    if (isempty(max_time)) max_time = 0; end;
    max_time_changed = true;   
    if (max_time > target_max_time) display('Error.'); return; end
    
    prefixes{1} = [0];
    prefixes{2} = [1];
    done = false;
    if (max_time == target_max_time) % Already have the largest max time from a previous iteration.
        done = true;
    end
    while (~done)
        % Get subset of tags to analyze.  These are the ones with times greater than max_time and less than or equal to target_max_time.
        if (max_time_changed)
            later_ids_indices = find((max_time < times) & (times <= target_max_time));
            later_ids = ids(later_ids_indices);
            later_ids_bin = ids_bin(later_ids_indices,:);
            later_times = times(later_ids_indices);
            num_later_ids = numel(later_ids);
        end
        max_time_changed = false;

        % Query tags and check how many tags respond.
        prefix = prefixes{1};
        mask = ones(num_later_ids,1) * prefix;
        prefix_len = numel(prefix);
        match_indices = find( sum( mask == later_ids_bin(:,1:prefix_len),2 ) == prefix_len );
        prefixes(1) = []; % Delete the current prefix.  Done with it.

        if (isempty(match_indices)) % No response.
            % Do nothing.
        elseif (numel(match_indices) == 1) % Single response.
            if ( later_times( match_indices(1) ) > max_time );
                max_time = later_times( match_indices(1) );
                collected_times = union(collected_times, max_time);
                max_time_changed = true;
                
                if (max_time == target_max_time)
                    done = true;
                end
            end
        else % Collision.
            if (prefix_len == num_bits) 
                error_msg = -1 % This should not happen.
            end
            prefixes{end+1} = [prefix 0];
            prefixes{end+1} = [prefix 1];
        end

        time_cost = time_cost + prefix_len + 17 + 113;

    end % while (~done)
    if (~isempty(prefixes))
        prefix = prefixes{1};
        prefix_len = numel(prefix);
        time_cost = time_cost + prefix_len + 17 + 113; % Last query to make sure that indeed have the largest time.
    end
    all_time_costs(iter) = time_cost;
end % for (iter = 1:num_max_times)


