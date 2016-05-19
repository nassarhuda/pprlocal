#read from store_nnz and plot
using NPZ
using Plots
# pyplot(size = (3,2.5), legend = false, grid = false)
pyplot()

total_number_of_instances = 5
p = [0.5;0.75;0.95]
alpha = [0.25;0.3;0.5;0.65;0.85]
delta = 2
w = 1:0.2:4
eps_accuracy = 10.^(-w)
N = 10^9
e = 9
eps_accuracy_reciprocal = 1./eps_accuracy

CLNNZ = join(["CL_NNZ_n=",N,".npz"])
AN2 = npzread(CLNNZ)
BKNNZ = join(["BK_NNZ_n=",N,".npz"])
AN = npzread(BKNNZ)
BOUND = join(["BOUND_n=",N,".npz"])
Bp = npzread(BOUND)

sfile = join(["CL_sizes_n=",N])
t = npzread(sfile)
n = t[1]

gc()

for i = 1:length(p)
    println("p val is $p")
    
    for j = 1:length(alpha)
        println("alpha val is $alpha")

        an = AN[i,j,:]
        an = vec(an)
        
        an2 = AN2[i,j,:]
        an2 = vec(an2)
        
        bp = Bp[i,j,:]
        bp = vec(bp)
        
        Plots.plot(eps_accuracy_reciprocal,an,lab ="Bisquik",w=1.25)
        
        Nsize = N*ones(Int64,length(eps_accuracy_reciprocal))
        Plots.plot!(eps_accuracy_reciprocal,Nsize,lab = "size of the graph",w=2.5,linecolor=colorant"black")
                
        Plots.plot!(eps_accuracy_reciprocal,bp,lab="Our bound on nnz",ylims = (10^4, N*10^3),w=1.25,
            linecolor=colorant"orange",linestyle=:dash)
        
        Plots.yaxis!(:log10)
        Plots.xaxis!(:log10)        
        imgfile = join(["n=",N,"p=",p[i],"alpha=",alpha[j]])
        

        
        loc = join(["BK_CL_1e",e,"/",imgfile,".pdf"])
        PyPlot.gcf()[:set_size_inches](3,2.5)
        PyPlot.gca()[:yaxis][:grid](color="lightgray", linestyle="solid", linewidth=0.4)
        PyPlot.gca()[:xaxis][:grid](color="lightgray", linestyle="solid", linewidth=0.4)
        Plots.plot!(eps_accuracy_reciprocal,Nsize,lab = "size of the graph",w=2.5,linecolor=colorant"black")
        savefig(loc)
        close()
        
    end
end