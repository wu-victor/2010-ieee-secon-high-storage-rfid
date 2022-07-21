clear all;

n_values = 1:1000;
N_values = 1:3000;

E0 = zeros(numel(n_values), numel(N_values));
E1 = zeros(numel(n_values), numel(N_values));
E2 = zeros(numel(n_values), numel(N_values));

for i = 1:numel(n_values)
    for j = 1:numel(N_values)
        n = n_values(i);
        N = N_values(j);
        E0(i,j) = N * (1-(1/N))^n;
        E1(i,j) = n * (1-(1/N))^(n-1);
        E2(i,j) = N - E0(i,j) - E1(i,j);
    end
end

save E_values.mat E0 E1 E2