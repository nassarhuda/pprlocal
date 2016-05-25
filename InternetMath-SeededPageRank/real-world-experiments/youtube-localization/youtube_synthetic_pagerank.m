clear
clc
load ../data/YouTube-ChungLu-adj.mat ;

% compute pagerank
% measure localization

degs = full(sum(A,1));
[seed, max] = max(degs);

alphas = [0.25, 0.5, 0.85];
n = size(A,1);
P = colnormout(A);

X = zeros(n,length(alphas));
eps_acc = 1e-12;
%%
for which_alpha = 1:length(alphas),
    alpha = alphas(which_alpha);
    
    v = sparse( seed, 1, 1-alpha, n, 1 );
    x = v;
    num_iters = log(eps_acc)/log(alpha) - 1;
    for which_ter = 1:num_iters,
        v = P*(alpha*v);
        x = x + v;
    end
    X(:,which_alpha) = x;
end

save('youtube_synthetic_pagerank_results.mat', 'X','alphas', 'eps_acc', 'degs');