function [dmax_ratio, decay_exp] = plot_deg_seq(fname, varargin)
% [dmax_ratio, a] = plot_deg_seq(fname, varargin)
%
% Plots degree sequence (log-log plot) of input graph
% and plots line of best fit by sampling 500 points equally spaced
% on a log scale across the sorted degree sequence.
%
% INPUTS
%   fname -- file name
%   'load_dir'      -- directory where data file is, default is './data/'
%   'show_fitline'  -- disply line of best fit, default is false
%   'print_toggle'  -- set to 1 to output images, default is 0
%   'which_axis'    -- set to 2 to use in-degrees instead of out-degrees,
%                      default value is 1.
%
% OUTPUTS
%
% dmax_ratio -- d = n^dmax_ratio
% decay_exp  -- slope of line of best fit on deg seq plot
%

% amazon0601-adj:  p =  -0.5245,    d = n^0.6137
% web-Google-adj:  p =  -0.7316,    d = n^0.6477


p = inputParser;
p.addOptional('print_toggle',false,@islogical);
p.addOptional('show_fitline',false,@islogical);
p.addOptional('which_axis',1);
p.addOptional('load_dir','../data/');
p.parse(varargin{:});

show_fitline = p.Results.show_fitline;
print_toggle = p.Results.print_toggle;
load_directory = p.Results.load_dir;
which_axis = p.Results.which_axis;

image_dir = './images/';
load( [load_directory, fname ] );
n = size(A,1);

assert( which_axis == 1 || which_axis == 2 );
degs = full(sum(A,which_axis));
degs = reshape(degs, 1,n);

x = [1:n];
y = sort(degs,'descend');
lx = log(x);
ly = log(y);
pts = [lx;ly];
clear A ;
%% TO GET THE POINTS equally spaced

close all;
a = min(pts(1,:));
b = max(pts(1,:));
f = 500;
v = linspace(a,b,f);

h = zeros(length(v),1);
t = pts(1,:);
for i = 1:length(v)
    h(i) = find(t>=v(i),1);
end
h = unique(h);
PTS = pts(:,h);
plot(PTS(1,:),PTS(2,:),'r');
hold on
plot(pts(1,:),pts(2,:),'x');

pts = PTS;
clear PTS
clear t
% pause(5)
close all
%%
N = size(pts,2);
rd1 = randperm(N);
rd2 = randperm(N);
maxiter = 200;
maxinliers = 400;
thresh = 0.5;
flag = true;
iter = 1;
inlierstotal = zeros(maxiter,1);

while iter < maxiter && flag
% for j = 1:10
    pt1 = pts(:,rd1(iter));
    pt2 = pts(:,rd2(iter));
    a = (pt2(2) - pt1(2))/(pt2(1) - pt1(1));
    b = -a*pt2(1) + pt2(2);
    
    ytemp = a*pts(1,:) + b;
    er = abs(ytemp - pts(2,:));
    
    inl = numel(find(er<thresh));
    inlierstotal(iter) = inl;
    
    if inl >= maxinliers
        flag = false;
    end
    
    iter = iter + 1;
end

[~,u] = max(inlierstotal);
pt1 = pts(:,rd1(u));
pt2 = pts(:,rd2(u));
a = (pt2(2) - pt1(2))/(pt2(1) - pt1(1));
b = -a*pt2(1) + pt2(2);

ytemp = a*pts(1,:) + b;
er = abs(ytemp - pts(2,:));
inl = numel(find(er<thresh));


pts = exp(pts);

plot(pts(1,:),pts(2,:),'b')

if show_fitline == true,
    hold on
    ytemp = exp(ytemp);
    plot(pts(1,:),ytemp,'r');
end
decay_exp = a;

dmax = max(degs);
n = length(degs);
dmax_ratio = log(dmax)/log(n);

% title( [fname], 'FontSize', 28 )
title( [fname] )
set(gca,'TitleFontWeight','normal')
xlim([1,n])
yl = ylim;
ylim([1,yl(2)])
set(gca,'xscale','log');
set(gca,'yscale','log');
% set(gca,'FontSize',23)     
tickall = [1,1e1,1e2,1e3,1e4,1e5,1e6,1e7,1e8,1e9];
xlims = xlim;
xmax = xlims(2);
set(gca, 'XTick', tickall(tickall < xmax))
ylims = ylim;
ymax = ylims(2);
set(gca, 'YTick', tickall(tickall < xmax))

set_figure_size([3,2.5]);
box off;
    
if print_toggle == 1, 
%     print( gcf, [image_dir, fname, '.png' ] , '-dpng');
        print( gcf, [image_dir, fname, '.eps' ]  , '-depsc2', '-loose');
end

