clear all;
format long g;

NUM_RAND = 100;

n_values = 1000:1000:1000;

avg_time_costs =  zeros(numel(n_values), 1);
for i = 1:numel(n_values)
    n = n_values(i)
    rand('state',1);
    
    total_time_costs = zeros(NUM_RAND, 1);
    for j = 1:NUM_RAND
        j
        TSP_QT;
        total_time_costs(j,1) = time_cost;
    end
    
    avg_time_costs(i,1) = mean(total_time_costs, 1)
end