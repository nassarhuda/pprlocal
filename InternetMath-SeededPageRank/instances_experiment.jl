include("create_graph_funcs.jl")
include("solve_local_PageRank3.jl")
using MatrixNetworks
using NPZ

function instances_experiment(n::Int64)
p = [0.5;0.75;0.95]
e = round(Int,log10(n))
dirloc = join(["BK_1e",e,"_instances"])
if !isdir(dirloc)
    mkdir(dirloc)
end

d = round(Int,sqrt(n))
delta = 2
total_instances_nb = 5
for instance = 1:total_instances_nb
println("instance started")
for i = 1:length(p)
    println("starting a new value of p")
    @time (src,dst,degs) = create_graph(p[i],n,d,delta)
    FT = zeros(Int64,length(src),2)
    FT[:,1] = src
    FT[:,2] = dst
    datafile = join(["instance_",instance,"_src_dst_n",log10(n),"_p",p[i],".npz"]);
    npzwrite(datafile,FT)
    FT = 0
    gc()
    degsfile = join(["degs_n",log10(n),"_p",p[i],".npz"]);
    npzwrite(degsfile,degs)
    
    println("started solving pagerank")
    P = sparse(src,dst,1./degs[dst],n,n)
    src = 0
    dst = 0
    degs = 0
    gc()
    bk = join([dirloc,"/BK_instance_",instance,"_"])
    @time solve_local_PageRank3(P,n,p[i],bk,n)
end
println("instance_ended")
end
end