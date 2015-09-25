% bound analysis plots
clear all
n = [1e4,1e5,1e6,1e7,1e8,1e9];
d = floor(n.^(1/2));
loc = [4,5,6,7,8,9];
alpha = [0.25 0.3 0.5 0.65 0.85];

eps_accuracy = [1e-1, 1e-2, 1e-3, 1e-4];
eps_accuracy_reciprocal = 1./eps_accuracy;

% Figure settings:
fontsize = 9;
linesize = 1;
figwidth = 3;
figheight = 2.5;


%% p experiment: p = 0.95 fixed
close all
figure
p = 0.95;load NNZEROS4_9p95.mat;
i = 3;% n =10^6

patterns = {'k','g','b','r','k--'}; 
for j = 1:5
c = NNZEROS(:,j,i);
ratios = c./(d(i)*log(d(i)));
xval = eps_accuracy_reciprocal;
loglog(xval,ratios,patterns{j},'LineWidth',linesize);
hold on;
end
title('varying \alpha','FontSize',fontsize);
xlabel('1/\epsilon','FontSize',fontsize);
ylabel('nonzeros(x_{\epsilon}) / d log(d)','FontSize',fontsize);
% set(gca,'AxesFontSize',40)
set_figure_size([figwidth,figheight])
% set(gca,'AxesFontSize',40)
print(gcf,strcat('../images/alphachange_p95_n6','.eps'),'-depsc2');
hold off;
%% alpha experiment:
figure
i = 3;% n = 10^6
j = 3;% alpha = 0.5
% p = 0.5
load NNZEROS4_9p5.mat
c = NNZEROS(:,j,i);
ratios = c./(d(i)*log(d(i)));
xval = eps_accuracy_reciprocal;
loglog(xval,ratios,'--','LineWidth',linesize);
hold on;
%
load NNZEROS4_9p75.mat
c = NNZEROS(:,j,i);
ratios = c./(d(i)*log(d(i)));
xval = eps_accuracy_reciprocal;
loglog(xval,ratios,'k-o','LineWidth',linesize);
hold on;

%
load NNZEROS4_9p95.mat
c = NNZEROS(:,j,i);
ratios = c./(d(i)*log(d(i)));
xval = eps_accuracy_reciprocal;
loglog(xval,ratios,'g-x','LineWidth',linesize);
hold on;


title('varying p','FontSize',fontsize);
xlabel('1/\epsilon','FontSize',fontsize);
ylabel('nonzeros(x_{\epsilon}) / d log(d)','FontSize',fontsize);

set_figure_size([figwidth,figheight])
print(gcf,strcat('../images/pchange_alpha5_n6','.eps'),'-depsc2');