using Plots
using NPZ
pyplot()

total_number_of_instances = 5

function plot_instances_results(n::Int64,p,alpha)
w = 1:0.2:4
eps_accuracy = 10.^(-w)

eps_accuracy_reciprocal = 1./eps_accuracy
e = round(Int,log10(n))

dirloc = join(["BK_1e",e,"_instances"])
for i = 1:length(p)
    for j = 1:length(alpha)
        for k = 1:total_number_of_instances
            file = join([dirloc,"/BK_instance_",k,"__PR_sln",e,".0_p",p[i],"_alpha",alpha[j],".npz"])
            X = npzread(file)
            X_sorted = sort(X)
            vsum = cumsum(X_sorted)
            AN = zeros(Float64,length(eps_accuracy))
            for h = 1:length(eps_accuracy)
                println("h is $h")
                index = findlast(vsum .< eps_accuracy[h])
                AN[h] = n - index
            end
            ins = join(["instance ",k])
            if k == 1
                Plots.plot(eps_accuracy_reciprocal,AN,lab = ins,ylims = (div(n,10^3), n*10^3),w = 1)
            else
                Plots.plot!(eps_accuracy_reciprocal,AN,lab = ins,ylims = (div(n,10^3), n*10^3), w =1)
            end
        end
        Plots.xaxis!(:log10, "\$1/\\varepsilon\$")
        Plots.yaxis!(:log10,"nonzeros retained")
        imgfile = join([dirloc,"/p=",p[i],"alpha=",alpha[j],"2.pdf"])
            
        PyPlot.gcf()[:set_size_inches](3,2.5)
        PyPlot.gca()[:yaxis][:grid](color="lightgray", linestyle="solid", linewidth=0.4)
        PyPlot.gca()[:xaxis][:grid](color="lightgray", linestyle="solid", linewidth=0.4)
        savefig(imgfile)
        close()
    end
end
end