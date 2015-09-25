function plot_theoretical_bound_new(d)

%%
% close all
n = [1e4,1e5,1e6,1e7,1e8,1e9];
loc = [4,5,6,7,8,9];
p = 0.95;
switch d %max degree
    case 1/4
        d = floor(n.^(1/4));
        load NNZ4_9p95n14alpha25-5.mat
    case 1/3
        d = floor(n.^(1/3));
        load NNZ4_9p95n13alpha25-5.mat
end


%%

delta = 2;% min degree - fixed
% alpha = [0.25 0.3 0.5 0.65];% alpha values
alpha = [0.25 0.5];
eps_accuracy = [1e-1, 1e-2, 1e-3, 1e-4];% eps accuracy

%%
fontsize_alpha = 10;
fontsize_n = 10;
subfontsize = 7;

linesize = 1.5;
figure;
cols = numel(n);
rows = numel(alpha);
eps_accuracy_reciprocal = 1./eps_accuracy;
for i = 1 : cols
    % d and n are indexed by i
    for j = 1 : rows
        % alpha is indexed by j
        c = NNZEROS(:,j,i);
        splot = subplot(rows,cols,(j-1)*cols+i, 'XScale', 'log', 'YScale', 'log', 'FontSize', subfontsize);
        ratios = c;
        Cp = d(i)*(1+(1/(1-p))*(d(i)^((1/p) - 1) - 1));
        if p==1, Cp = d(i)*(1+log(d(i))); end
        xval = eps_accuracy_reciprocal;
        
        % plot 1 - actual non zeros
        loglog(xval,ratios,'x-','LineWidth',linesize);
        hold on;
        
        % plot 2 -the upper limit possible with all n (indep of eps)
        nsize = n(i);
        loglog(xval,...
            nsize*ones(size(eps_accuracy_reciprocal)),...
            'r--','LineWidth',linesize);
        
        hold on;
        % plot 3: yvalues = (1/eps)^(1/(1-alpha)) - the actual upper lim
        val3 = Cp*(1/delta)*(eps_accuracy_reciprocal).^(delta/(1-alpha(j)));
        loglog(xval,val3,...
            'k-','LineWidth',1);

        
        if j == 1
            str = strcat('n = 10^', num2str(loc(i)));
            title(str,'FontSize', fontsize_alpha);
        end
        
        if i == 1
            str = strcat('\alpha = ', num2str(alpha(j)));
            ylabel(str,'FontSize', fontsize_n);
        end
        
        xlim([10,10000])
        ylim([1,max(n(i),100*val3(1))])
    end
end
%str = strcat('p value = ', num2str(p));
str = sprintf('p value = %4.2f',p);
%suptitle(str)
set_figure_size([8,2]);
print(gcf,strcat('../images/theoretical_bound.eps'),'-depsc2');
end

