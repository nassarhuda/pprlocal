using Plots
pyplot()
using NPZ

total_number_of_instances = 5
p = [0.5;0.75;0.95]
alpha = [0.25;0.3;0.5;0.65;0.85]
delta = 2
w = 1:0.2:4
eps_accuracy = 10.^(-w)
N = 10^4
e = 4
eps_accuracy_reciprocal = 1./eps_accuracy
for i = 1:length(p)
    println("p val is $p")
    dfile = join(["BK_1e",e,"/degs_n",log10(N),"_p",p[i],".npz"])
    degs = npzread(dfile)
    dmax = degs[1]
    Cp = dmax*(1+(1/(1-p[i]))*(dmax^((1/p[i])-1)-1))
    degs = 0
    
    dfile2 = join(["CL_1e",e,"/CL_degs_n",log10(N),"_p",p[i],".npz"])
    degs2 = npzread(dfile2)
    dmax2 = degs2[1]
    degs2 = 0
    
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
        end
        
        Plots.plot(eps_accuracy_reciprocal,AN,lab ="Bisquik",
        yaxis=(:log10,"nonzeros retained"), xaxis=(:log10, "\$1/\\varepsilon\$"))
        
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
            #Bp[h] = 1 + dmax + (1/delta)*Cp*((alpha[j]^2/eps_accuracy[h])^(delta/(1-alpha[j])))
            Bp[h] = 1 + dmax + (1/(delta-1))*Cp*((alpha[j]^2/eps_accuracy[h])^((delta-1)/(1-alpha[j])))
        end
        
        Plots.plot!(eps_accuracy_reciprocal,AN,lab="Chung-Lu")
        
        # plot 3 - the upper limit possible with all n (indep of eps)
        nsize = N*ones(Int64,length(eps_accuracy_reciprocal))
        Plots.plot!(eps_accuracy_reciprocal,nsize,lab = "size of the graph")
        
        # plot 4 - bound
        Plots.plot!(eps_accuracy_reciprocal,Bp,lab="Our bound on nnz")
   
        imgfile = join(["n=",N,"p=",p[i],"alpha=",alpha[j]])
        
        if j == 1 # plotting the first alpha
            tt = join(["p = ",p[i]])
            Plots.title!(tt)
        end
        
        if i == 1
            jj = join(["alpha = ",alpha[j]])
            Plots.ylabel!(jj)
        end
        
        loc = join(["BK_CL_1e",e,"/",imgfile,".pdf"])
        PyPlot.gcf()[:set_size_inches](3,2.5)
        PyPlot.gca()[:yaxis][:grid](color="gray", linestyle="solid", linewidth=0.4)
        PyPlot.gca()[:xaxis][:grid](color="gray", linestyle="solid", linewidth=0.4)
        savefig(loc)
        close()
    end
end