clear all;

format long g;

NUM_RAND = 100;

n_values = 100:100:1000;

avg_time_cost =  zeros(numel(n_values), 1);
for i = 1:numel(n_values)
    n = n_values(i)
    rand('state',1);
    
    total_time_cost = zeros(NUM_RAND, 1);
    for j = 1:NUM_RAND
        query_tree_nonsegment;
        total_time_cost(j,1) = time_cost;
    end
    
    avg_time_cost(i,1) = mean(total_time_cost, 1)
end

