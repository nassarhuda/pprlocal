# script that generates a chung lu graph, and solve seeded PageRank on it
include("chung_lu.jl")
include("solve_local_PageRank3.jl")
using MatrixNetworks
using NPZ
p = [0.5;0.75;0.95]
function runscript_CL(n::Int64)
N = copy(n)
d = round(Int,sqrt(n))
m = round(Int,n+1.2*n)
delta = 2
for i = 1:length(p)
    println("starting a new value of p")
    @time (A,deg,src,dst) = chung_lu(p[i],m,d,delta)
    deg = 0
    src = 0
    dst = 0
    gc()
    cc = scomponents(A)
    
    lcc = cc.sizes[1]
    println("lcc is $lcc")
    if lcc >= .95*N
        V = enrich(cc)
        B = V.reduction_matrix
        V = 0
        gc()

        l = B[:,1]
        B = 0
        gc()

        l = full(l)
        k = find(l)
        l = 0
        gc()

        B = A[k,k]
        degs = sum(B,2)
        src,dst = findnz(B)
        B = 0
        A = 0
        k = 0
        gc()
    
    
        FT = zeros(Int64,length(src),2)
        FT[:,1] = src
        FT[:,2] = dst
        datafile = join(["CL_src_dst_n",log10(N),"_p",p[i],".npz"]);
        npzwrite(datafile,FT)
        FT = 0
        gc()
        degsfile = join(["CL_degs_n",log10(N),"_p",p[i],".npz"]);
        npzwrite(degsfile,degs)
    
        n = max(maximum(src),maximum(dst))
        println("started solving pagerank")
        P = sparse(src,dst,1./degs[dst],n,n)
        src = 0
        dst = 0
        degs = 0
        gc()
        @time solve_local_PageRank3(P,n,p[i],"CL",N)
        println("was here")
    end
    println("lcc is $lcc")
end
end