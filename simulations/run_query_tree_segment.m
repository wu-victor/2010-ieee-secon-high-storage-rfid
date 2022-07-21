clear all;
format long g;

NUM_RAND = 100;

n_values = 100:100:1000;
num_max_times = 20; % Top number of largest times wanted.

avg_time_cost =  zeros(numel(n_values), num_max_times);
for i = 1:numel(n_values)
    n = n_values(i)
    rand('state',1);

    total_time_cost = zeros(NUM_RAND, num_max_times);
    for (j = 1:NUM_RAND)
        query_tree_segment
        total_time_cost(j,:) = all_time_costs;
    end
    
    avg_time_cost(i,:) = mean(total_time_cost, 1)
end
