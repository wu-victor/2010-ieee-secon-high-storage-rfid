clear all;

load E_values.mat;

NUM_RAND = 100;

n_values = 100:100:1000;
num_max_times = 20; % Top number of largest times wanted.

avg_time_costs =  zeros(numel(n_values), num_max_times);
for i = 1:numel(n_values)
    n = n_values(i)
    rand('state',1);
    
    total_time_costs = zeros(NUM_RAND, num_max_times);
    for (j = 1:NUM_RAND)
        if (mod(j,10)==0)
            n
            j
        end
        aloha_half
        total_time_costs(j,:) = all_time_costs;
    end
    
    avg_time_costs(i,:) = mean(total_time_costs, 1);
end
