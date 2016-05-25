# experiment to check the localization pattern on graph size 10^9, p = .95, alpha = .85
# read from store_nnz and plot
using NPZ
using Plots
pyplot()

total_number_of_instances = 5
p = 0.95
alpha = 0.85

delta = 2
w = 1:0.2:4
eps_accuracy = 10.^(-w)
N = 10^9
e = 9
eps_accuracy_reciprocal = 1./eps_accuracy

dmax = round(Int,sqrt(N))

BKNNZ = join(["BK_NNZ_n=",N,".npz"])
AN = npzread(BKNNZ)
BOUND = join(["BOUND_n=",N,".npz"])
Bp = npzread(BOUND)

gc()
Cp = dmax*(1+(1/(1-p))*(dmax^((1/p)-1)-1))
Dp = dmax*(1+log(eps_accuracy_reciprocal)/log(1/alpha))


i = 3
j = 5


an = AN[i,j,:]
an = vec(an)
        
bp = Bp[i,j,:]
bp = vec(bp)
        
Plots.plot(eps_accuracy_reciprocal,an,lab ="Bisquik",w=1.25)
        
Nsize = N*ones(Int64,length(eps_accuracy_reciprocal))
Plots.plot!(eps_accuracy_reciprocal,Nsize,lab = "size of the graph",w=2.5,linecolor=colorant"black")

Plots.plot!(eps_accuracy_reciprocal,Dp,lab = "Dp",w=0.75,ylims = (10^4, N*10^3),w=1.25,linecolor=colorant"green")
        
Plots.xaxis!(:log10, "\$1/\\varepsilon\$")
Plots.yaxis!(:log10,"nonzeros retained")

imgfile = join(["block_n=",e,"p=",p,"alpha=",alpha,"2.pdf"])
        
PyPlot.gcf()[:set_size_inches](3,2.5)
PyPlot.gca()[:yaxis][:grid](color="lightgray", linestyle="solid", linewidth=0.4)
PyPlot.gca()[:xaxis][:grid](color="lightgray", linestyle="solid", linewidth=0.4)
savefig(imgfile)
close()