time_cost = 0;

id_len = 96; % Length of a tag ID in bits.
   
% Generate n unique tag IDs.  
tag_ids_bin = [];
while (size(tag_ids_bin,1) < n)
    id_bin = randint(1,id_len);
    if (~(sum(ismember(tag_ids_bin, id_bin, 'rows')) > 0))
        tag_ids_bin(end+1,:) = id_bin;
    end
end

% Pick a random tag ID to start (possibly not in the n unique tag IDs), and find the root.
test_root = randint(1,id_len);
prefix_len = length(test_root);    
found_root = false; 
while (~found_root)
    time_cost = time_cost + prefix_len + 96;
    
    % Test if we are at a valid root.
    test_matrix = ones(n,1) * test_root; % Each row is the test_root.
    if ( numel( find( sum( test_matrix == tag_ids_bin(:,1:prefix_len), 2 ) == prefix_len ) ) > 0 ) % Check if test_root is a prefix of any tag.
        % Yes, the root is valid.
        found_root = true;
    else
        % No, the root is not valid.  Find the next one to check.
        if (test_root(end) == 0) % Left node.  Just move right.
            test_root(end) = 1;
        else % Right node. Move up.
            test_root(end) = []; 
            prefix_len = length(test_root);
            if ( sum(test_root) == prefix_len ) % All ones.  Wrap around.
                test_root = zeros(1,prefix_len);
            else
                test_root = bin_add_one(test_root); % Move right.         
            end
        end
    end        
end % while (~found_root)
       
% Find the most left leaf of this subtree with this root.  This is the node
% we are after.
root = test_root;
test_matrix = ones(n,1) * root;
prefix_len = length(root);
num_matches = numel( find( sum( test_matrix == tag_ids_bin(:,1:prefix_len), 2 ) == prefix_len ) );
if (num_matches == 0) display('Error.');
elseif (num_matches == 1) done = true;
else done = false; % Try left and right subtrees.
end
time_cost = time_cost + prefix_len + 96;
while (~done)
    try_right = false; % Try right subtree only if necessary.
    
    left_query = [root 0];
    test_matrix = ones(n,1) * left_query;
    prefix_len = length(left_query);
    num_matches = numel( find( sum( test_matrix == tag_ids_bin(:,1:prefix_len), 2 ) == prefix_len ) );
    if (num_matches == 0) try_right = true;
    elseif (num_matches == 1) done = true;
    else root = [root 0]; % Continue down left subtree.
    end
    time_cost = time_cost + prefix_len + 96;
    
    if (try_right)
    	right_query = [root 1];
        test_matrix = ones(n,1) * right_query;
        prefix_len = length(right_query);
        num_matches = numel( find( sum( test_matrix == tag_ids_bin(:,1:prefix_len), 2 ) == prefix_len ) );
        if (num_matches == 0) display('Error.'); return;
        elseif (num_matches == 1) done = true;
        else root = [root 1]; % Continue down right subtree.
        end
        time_cost = time_cost + prefix_len + 96;
    end
end


