function plot_conjectured_bound_new(p)

%%
close all
n = [1e4,1e5,1e6,1e7,1e8,1e9];
loc = [4,5,6,7,8,9];
imagetitle = '';
switch p
    case 0.5
        load NNZEROS4_9p5.mat
        imagetitle = 'pval5';
    case 0.75
        load NNZEROS4_9p75.mat
        imagetitle = 'pval75';
    case 0.95
        load NNZEROS4_9p95.mat
        imagetitle = 'pval95';
end

%%

d = floor(n.^(1/2));% max degree
delta = 3;% min degree - fixed
alpha = [0.25 0.3 0.5 0.65 0.85];% alpha values
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
        val3 = d(i)*log(d(i))*...
            ((0.2/(1-alpha(j)))*(eps_accuracy_reciprocal).^(1/(2*p)^2));
        loglog(xval,val3,...
            'k--','LineWidth',linesize);
        
%         xlhand = get(splot,'xlabel');
%         set(xlhand,'fontsize',subfontsize);
%         ylhand = get(splot,'ylabel');
%         set(ylhand,'fontsize',subfontsize);
        
%        set( get(splot,'XLabel'), 'String', 'This is the X label' );
        
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
%str = strcat('p value = ',num2str(p));
str = sprintf('p value = %4.2f',p);
suptitle(str)
print(gcf,strcat('../images/',imagetitle,'.eps'),'-depsc2');
end

