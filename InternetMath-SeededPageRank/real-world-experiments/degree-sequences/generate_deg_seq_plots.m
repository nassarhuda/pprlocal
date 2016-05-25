
clear
clc

file_list = dir('../data/*.mat');
num_files = length(file_list);

dexps = zeros( num_files, 1 );
pexps = zeros( num_files, 1 );

deg_seqs.fnames = cell( num_files, 1 );
deg_seqs.dexps = zeros( num_files, 1 );
deg_seqs.pexps = zeros( num_files, 1 );

fprintf( '\n' )
for j=1:num_files,
    fname = file_list(j).name;

    deg_seqs.fnames{j} = fname;
    
    [dexps(j), pexps(j)] = plot_deg_seq(fname(1:end-4) , 'print_toggle', true, 'show_fitline', true );
    
%    fprintf( ' %s ,  d = n^%3.4f  ,  p = %3.4f \n',  fname(1:end-4), dexps(j), pexps(j) )
end

pexps = -pexps;
[~,inds] = sort(pexps, 'descend');

deg_seqs.fnames = deg_seqs.fnames(inds);
deg_seqs.dexps = dexps(inds);
deg_seqs.pexps = pexps(inds);
save( 'degree_seq_info.mat', 'deg_seqs');

fprintf( '\n GENERATE_DEG_SEQ_PLOTS DONE \n' );

