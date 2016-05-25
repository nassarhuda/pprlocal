using Plots
pyplot(legend = false)
using NPZ

function plot_bound(N::Int64)
p = [0.5;0.75;0.95]
alpha = [0.25;0.3;0.5;0.65;0.85]
delta = 2
w = 1:0.2:4
eps_accuracy = 10.^(-w)
e = round(Int,log10(N))
eps_accuracy_reciprocal = 1./eps_accuracy
dirloc = join(["BK_CL_1e",e])
if !isdir(dirloc)
    mkdir(dirloc)
end
for i = 1:length(p)
    println("p val is $p")
    dfile = join(["BK_1e",e,"/degs_n",log10(N),"_p",p[i],".npz"])
    degs = npzread(dfile)
    dmax = degs[1]
    Cp = dmax*(1+(1/(1-p[i]))*(dmax^((1/p[i])-1)-1))
    degs = 0
    
    gc()
    for j = 1:length(alpha)
        file = join(["BK_1e",e,"/BK_PR_sln",log10(N),"_p",p[i],"_alpha",alpha[j],".npz"])
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
        
        Plots.plot(eps_accuracy_reciprocal,AN,lab ="Bisquik",w=1.25)
        
        Nsize = N*ones(Int64,length(eps_accuracy_reciprocal))
        Plots.plot!(eps_accuracy_reciprocal,Nsize,lab = "size of the graph",w=2.5,linecolor=colorant"black")
        
        Plots.plot!(eps_accuracy_reciprocal,Bp,lab="Our bound on nnz",ylims = (div(N,10^3), N*10^3),w=1.25,
            linecolor=colorant"orange",linestyle=:dash)
            
        Plots.yaxis!(:log10)
        Plots.xaxis!(:log10)        
        imgfile = join(["n=",N,"p=",p[i],"alpha=",alpha[j]])
        
        loc = join([dirloc,"/",imgfile,".pdf"])
        PyPlot.gcf()[:set_size_inches](3,2.5)
        PyPlot.gca()[:yaxis][:grid](color="lightgray", linestyle="solid", linewidth=0.4)
        PyPlot.gca()[:xaxis][:grid](color="lightgray", linestyle="solid", linewidth=0.4)
        Plots.plot!(eps_accuracy_reciprocal,Nsize,lab = "size of the graph",w=2.5,linecolor=colorant"black")
        savefig(loc)
        close()
    end
end
end