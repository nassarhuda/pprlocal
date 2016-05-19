using Plots
using NPZ
pyplot(size = (700,700), legend = false)
default(guidefont = font(20), tickfont = font(15))
total_number_of_instances = 5
p = [0.5;0.75;0.95]
alpha = [0.25;0.3;0.5;0.65;0.85]
delta = 2
w = 1:0.2:4
eps_accuracy = 10.^(-w)
N = 10^7
eps_accuracy_reciprocal = 1./eps_accuracy
for i = 1:length(p)
    dfile = join(["degs_n",log10(N),"_p",p[i],".npz"])
    degs = npzread(dfile)
    degs = sort(degs,rev=true)
    dmax = degs[1]
    Cp = dmax*(1+(1/(1-p[i]))*(dmax^((1/p[i])-1)-1))
    degs = 0
    gc()
    for j = 1:length(alpha)
        file = join(["BK_PR_sln",log10(N),"_p",p[i],"_alpha",alpha[j],".npz"])
        X = npzread(file)
        n = length(X)
        X_sorted = sort(X)
        vsum = cumsum(X_sorted)
        AN = zeros(Float64,length(eps_accuracy))
        Bp = zeros(Float64,length(eps_accuracy))
        HN = zeros(Float64,length(eps_accuracy))
        for h = 1:length(eps_accuracy)
            println("h is $h")
            index = findlast(vsum .< eps_accuracy[h])
            AN[h] = n - index
            Bp[h] = 1 + dmax + (1/delta)*Cp*((alpha[j]^2/eps_accuracy[h])^(delta/(1-alpha[j])))
            HN[h] = dmax * log(dmax) *(0.2/(1-alpha[j]))*(1/eps_accuracy[h])^(1/(4*p[i]^2))
        end
        
        Plots.plot(eps_accuracy_reciprocal,AN,ylims = (1, 1000*N))
        
        # plot 2 - the upper limit possible with all n (indep of eps)
        nsize = N*ones(Int64,length(eps_accuracy_reciprocal))
        Plots.plot!(eps_accuracy_reciprocal,nsize)
        
        # plot 3 - bound
        Plots.plot!(eps_accuracy_reciprocal,Bp,ylims = (1, 1000*N))
        
        # plot 4 - conjectured bound
        Plots.plot!(eps_accuracy_reciprocal,HN,ylims = (1, 1000*N))
        
        Plots.yaxis!(:log10)
        Plots.xaxis!(:log10)        
        imgfile = join(["n=",N,"p=",p[i],"alpha=",alpha[j]])
        
        if j == 1 # plotting the first alpha
            tt = join(["p = ",p[i]])
            Plots.title!(tt)
        end
        
        jj = join(["alpha = ",alpha[j]])
        Plots.ylabel!(jj)

        png(imgfile)
    end
end