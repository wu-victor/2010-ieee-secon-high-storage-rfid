num_bits = 96; % Number of bits in tag ID.

%%%%%%%%%%%%%%%%%%%%
% Generate tag IDs. 
%%%%%%%%%%%%%%%%%%%%
ids = [];
while (numel(ids) < n)
    id = ceil(rand()*2^num_bits); id(id==0) = 1;
    id = id - 1;
    if (~ismember(id,ids))
        ids(end+1) = id;
    end
end
ids_bin = dec2bin(ids, num_bits) == '1';

%%%%%%%%%%%%%%%%%
% Do query tree.
%%%%%%%%%%%%%%%%%
time_cost = 0;
num_singulated = 0;

prefixes{1} = [0];
prefixes{2} = [1];
done = false;
while (~done)

    % Query tags and check how many tags respond.
    prefix = prefixes{1};
    mask = ones(n,1) * prefix;
    prefix_len = numel(prefix);
    match_indices = find( sum( mask == ids_bin(:,1:prefix_len),2 ) == prefix_len );
    prefixes(1) = []; % Delete the current prefix.  Done with it.

    if (isempty(match_indices)) % No response.
        % Do nothing.
    elseif (numel(match_indices) == 1) % Single response.
        % Singulated the ID.  Do nothing.
        num_singulated = num_singulated + 1;
    else % Collision.
        if (prefix_len == num_bits) 
            error_msg = -1 % This should not happen.
        end
        prefixes{end+1} = [prefix 0];
        prefixes{end+1} = [prefix 1];
    end

    if (isempty(prefixes))
        done = true;
    end
    time_cost = time_cost + prefix_len + 113;
end % while (~done)

if (num_singulated ~= n) 
    error_msg = -1 
end

