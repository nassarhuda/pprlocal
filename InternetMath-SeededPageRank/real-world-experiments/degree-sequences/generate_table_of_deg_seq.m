clc
clear

load degree_seq_info.mat ;

num_old_files = length( deg_seqs.fnames );
fnames = cell( num_old_files + 6  , 1) ;
dexps = zeros( num_old_files + 6  , 1) ;
pexps = zeros( num_old_files + 6  , 1) ;

fnames(1:num_old_files) = deg_seqs.fnames;
dexps(1:num_old_files) = deg_seqs.dexps;
pexps(1:num_old_files) = deg_seqs.pexps;
%%
k=1;
fnames{num_old_files+k} = 'youtube-adj';
dexps(num_old_files+k) = 0.7364;
pexps(num_old_files+k) = 0.7625;
k=2;
fnames{num_old_files+k} = 'orkut-adj';
dexps(num_old_files+k) = 0.6971; 
pexps(num_old_files+k) = 0.5284;
k=3;
fnames{num_old_files+k} = 'lj-adj';
dexps(num_old_files+k) = 0.6317;
pexps(num_old_files+k) = 0.5125;
k=4;
fnames{num_old_files+k} = 'friendster-adj';
dexps(num_old_files+k) = 0.4755;
pexps(num_old_files+k) =  0.4059;
k=5;
fnames{num_old_files+k} = 'amazon-adj';
dexps(num_old_files+k) = 0.4959;
pexps(num_old_files+k) =  0.4193;
k=6;
fnames{num_old_files+k} = 'dblp-adj';
dexps(num_old_files+k) =  0.9768;
pexps(num_old_files+k) =  0.4671;



[~,inds] = sort(pexps, 'descend');
num_files = length(pexps);

pexps = pexps(inds);
dexps = dexps(inds);
fnames = fnames(inds);

fprintf( '\n\n \\toprule \n' )
fprintf( ' data  &  p   &   $\\log_n(d) $  &  $ \\log_n(C_p) $    \\\\ \n \\midrule \n' )
for j=1:num_files,
    fname = fnames{j};
    d = dexps(j);
    p = pexps(j);
    fprintf( ' \\texttt{ %20.25s } &  %3.2f  &  %3.2f  &  %3.2f  \\\\ \n',  fname(1:end-4), p, d, d/p );
end




fprintf( '\\bottomrule \n' )