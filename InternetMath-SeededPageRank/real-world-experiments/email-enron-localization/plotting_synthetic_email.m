clc
clear

addpath ../

load email_synthetic_pagerank_results.mat
X2 = X;
degs2 = degs;
load email_pagerank_results.mat
X1 = X;
degs1 = degs;
clear X degs;

alphas = [0.25, 0.5, 0.85];

w = [1:0.2:4];
accs = 10.^(-w);
n = length(X1);
num_alpha = size(X1,2);

degs1 = sort(degs1, 'descend');
degs2 = sort(degs2, 'descend');
%%
clf
    plot( [1:n], degs1, 'b')
    hold on
    plot( [1:n], degs2, 'r');

    xlabel( 'Node rank' )
    ylabel( 'Node degree' )

    legend( 'Email-Enron', 'Synthetic', 'Location', 'NorthEast');
    legend boxoff

    xlim( [1,n] )

    set(gca,'xscale','log');
    set(gca,'yscale','log');
    tickall = [1,1e1,1e2,1e3,1e4,1e5,1e6,1e7,1e8,1e9];
    xlims = xlim;
    xmax = xlims(2);
    set(gca, 'XTick', tickall(tickall < xmax))
    ylims = ylim;
    ymax = ylims(2);
    set(gca, 'YTick', tickall(tickall < ymax))

    set_figure_size([3,2.5]);
    box off;

    print( gcf, [ 'Email-enron-v-synth-degrees',  '.eps' ] , '-depsc2', '-loose');
   
    fprintf( '\n DEG SEQ DONE FOR EMAIL, SYTHETIC EMAIL\n' );
%%
for which_alpha = 1:num_alpha,
    clf
    x1 = X1(:,which_alpha);
    x2 = X2(:,which_alpha);
    x1 = sort(x1,'descend');
    x2 = sort(x2,'descend');
    c1 = 1-cumsum(x1);
    c2 = 1-cumsum(x2);
    AN = zeros( length(accs), 2 );
    for h = 1:length(accs),
        index1 = find( c1 < accs(h), 1 );
        index2 = find( c2 < accs(h), 1 );
        AN( h, 1 ) = index1;
        AN( h, 2 ) = index2;
    end
    plot( 1./accs', AN(:,1), 'b' );
    hold on
    plot( 1./accs', AN(:,2), 'r--' );

    xlabel( '1/\epsilon' )
    ylabel( 'Nonzeros retained' )    
    ylim( [ 1, n] );
    xlim( [ 1e1, 1e4] );
    legend( 'Email-Enron', 'Synthetic', 'Location', 'SouthEast');
    legend boxoff
    
    set(gca,'xscale','log');
    set(gca,'yscale','log');
    tickall = [1,1e1,1e2,1e3,1e4,1e5,1e6,1e7,1e8,1e9];
    xlims = xlim;
    xmax = xlims(2);
    set(gca, 'XTick', tickall(tickall <= xmax))
    ylims = ylim;
    ymax = ylims(2);
    set(gca, 'YTick', tickall(tickall < ymax))

    set_figure_size([3,2.5]);
    box off;
    print( gcf, [ 'Email-enron-v-synth', num2str(which_alpha),'-',num2str(alphas(which_alpha)), '.eps' ] , '-depsc2', '-loose');
end

fprintf( '\n LOCALIZATION DONE FOR EMAIL, SYTHETIC EMAIL\n' );
