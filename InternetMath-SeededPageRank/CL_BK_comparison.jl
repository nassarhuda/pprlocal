using NPZ
using Plots
pyplot()
include("create_graph_funcs.jl")
include("solve_local_PageRank3.jl")



## read CL degree seq and use bisquik to generate the graph and then solve PR
function CL_BK_comparison(n,p,alpha)

N = copy(n)
ex = round(Int,log10(n))
dirloc = join(["TT_BK_CL_1e",ex])
if !isdir(dirloc)
    mkdir(dirloc)
end

fn = join(["CL_1e",ex,"/CL_degs_n",ex,".0_p",p,".npz"])
degs = npzread(fn)
degs = vec(degs)
degs = sort(degs,rev=true)
n = length(degs)
dmax = degs[1]
dmin = degs[end]
(src,dst,l) = bisquik_graph(degs,10,n)
P = sparse(src,dst,1./degs[dst],n,n)
solve_local_PageRank3(P,n,p,"TT",N)

delta = 2
w = 1:0.2:4
eps_accuracy = 10.^(-w)

e = ex
eps_accuracy_reciprocal = 1./eps_accuracy
for i = 1:length(p)
    println("p val is $p")
    dfile = join(["CL_1e",e,"/CL_degs_n",log10(N),"_p",p[i],".npz"])
    degs = npzread(dfile)
    dmax = degs[1]
    Cp = dmax*(1+(1/(1-p[i]))*(dmax^((1/p[i])-1)-1))
    degs = 0
    
    gc()
    for j = 1:length(alpha)
        file = join(["TT_PR_sln",log10(N),"_p",p[i],"_alpha",alpha[j],".npz"])
        X = npzread(file)
        n = length(X)
        X_sorted = sort(X)
        vsum = cumsum(X_sorted)
        AN = zeros(Float64,length(eps_accuracy))
        Bp = zeros(Float64,length(eps_accuracy))
        for h = 1:length(eps_accuracy)
            index = findlast(vsum .< eps_accuracy[h])
            AN[h] = n - index
        end
        
        Plots.plot(eps_accuracy_reciprocal,AN,lab ="Bisquik",ylims = (1, 10*N),w=1.25)
        
        file = join(["CL_1e",e,"/CL_PR_sln",log10(N),"_p",p[i],"_alpha",alpha[j],".npz"])
        X = npzread(file)
        n = length(X)
        X_sorted = sort(X)
        vsum = cumsum(X_sorted)
        AN = zeros(Float64,length(eps_accuracy))
        Bp = zeros(Float64,length(eps_accuracy))
        for h = 1:length(eps_accuracy)
            index = findlast(vsum .< eps_accuracy[h])
            AN[h] = n - index
            Bp[h] = 1 + dmax + (1/(delta-1))*Cp*((alpha[j]^2/eps_accuracy[h])^((delta-1)/(1-alpha[j])))
        end
        
        Plots.plot!(eps_accuracy_reciprocal,AN,lab="Chung-Lu", ylims = (1, 1000*N),w=1.25, linestyle=:dash)
        
        Nsize = N*ones(Int64,length(eps_accuracy_reciprocal))
        Plots.plot!(eps_accuracy_reciprocal,Nsize,lab = "size of the graph",w=2.5,linecolor=colorant"black")
        
        Plots.xaxis!(:log10, "\$1/\\varepsilon\$")
        Plots.yaxis!(:log10,"nonzeros retained")
        imgfile = join(["n=",N,"p=",p[i],"alpha=",alpha[j]])
        
        loc = join([dirloc,"/",imgfile,".pdf"])
        PyPlot.gcf()[:set_size_inches](3,2.5)
        PyPlot.gca()[:yaxis][:grid](color="lightgray", linestyle="solid", linewidth=0.4)
        PyPlot.gca()[:xaxis][:grid](color="lightgray", linestyle="solid", linewidth=0.4)
        savefig(loc)
        close()

    end
end
end