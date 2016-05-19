include("create_graph_funcs.jl")
include("solve_local_PageRank3.jl")
using MatrixNetworks
using NPZ

## battle of norms script
p = 0.95
alpha = 0.85
N = 10^7
n = 10^7
e = 7

q = 2:0.02:7
w = [collect(1:100);ceil(10.^q)]
w = round(Int,collect(w))
m = length(w)

ALLNORMS = zeros(Float64,m,4)

dfile = join(["BK_1e",e,"/degs_n",log10(N),"_p",p,".npz"])
degs = npzread(dfile)
Dinv = 1./degs

file = join(["BK_1e",e,"/BK_PR_sln",log10(N),"_p",p,"_alpha",alpha,".npz"])
X = npzread(file)

X_sorted = sort(X,rev=true)
    
# L1 norm
for t = 1:m
    A1 = X_sorted[w[t]:n]
    ALLNORMS[t,1] = norm(A1,1)
end
    
# L2 norm
for t = 1:m
    Y2 = X_sorted[w[t]:n]
    ALLNORMS[t,2] = norm(Y2)
end

# D^{-1}X
W1 = Dinv.*X
W2 = sort(W1,rev=true)
for t = 1:m
    B1 = W2[w[t]:n]
    ALLNORMS[t,3] = norm(B1,1)
end
    
V1 = Dinv.*X
V2 = sort(V1,rev=true)
for t = 1:m
    V3 = V2[w[t]:n]
    ALLNORMS[t,4] = norm(V3)
end

filename = "ALLNORMS.npz"
npzwrite(filename,ALLNORMS)
#######################################
using Plots
pyplot()
AN = npzread("ALLNORMS.npz")
Plots.plot(w,AN[:,1],lab = "1-norm", w = 1)
Plots.plot!(w,AN[:,2], lab = "2-norm", w = 1)
Plots.plot!(w,AN[:,3], lab = "\$D^{-1}\$X 1-norm", w = 1, ylims = (10.0^(-10),1))
Plots.plot!(w,AN[:,4], lab = "\$D^{-1}\$X 2-norm", w = 1, ylims = (10.0^(-10),1))
Plots.yaxis!(:log10,"norm error")
Plots.xaxis!(:log10, "nonzeros retained")    

PyPlot.gcf()[:set_size_inches](3,2.5)
PyPlot.gca()[:yaxis][:grid](color="lightgray", linestyle="solid", linewidth=0.4)
PyPlot.gca()[:xaxis][:grid](color="lightgray", linestyle="solid", linewidth=0.4)
tt = join(["battle_n=",e,"p=",p,"alpha=",alpha,".pdf"])
savefig(tt)
close()
