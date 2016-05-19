using Plots
using NPZ
# pyplot(size = (900,900), legend = false)
# PyPlot.gcf()[:set_size_inches](4.,3.)
# default(guidefont = font(30), tickfont = font(25))
total_number_of_instances = 5
# p = [0.5;0.75;0.95]
# p = [0.5;0.95]
p = 0.95
# alpha = [0.25;0.3;0.5;0.65;0.85]
# alpha = [0.25;0.85]
alpha = 0.85
w = 1:0.2:4
eps_accuracy = 10.^(-w)
n = 10^7
eps_accuracy_reciprocal = 1./eps_accuracy
for i = 1:length(p)
    for j = 1:length(alpha)
        for k = 1:total_number_of_instances
            file = join(["BK_instance_",k,"__PR_sln7.0_p",p[i],"_alpha",alpha[j],".npz"])
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
                Plots.plot(eps_accuracy_reciprocal,AN,lab = ins,ylims = (10^3, 10^7),w = 1)
            else
                Plots.plot!(eps_accuracy_reciprocal,AN,lab = ins,ylims = (10^3, 10^7), w =1)
            end
        end
        Plots.xaxis!(:log10, "\$1/\\varepsilon\$")
        Plots.yaxis!(:log10,"nonzeros retained")
        imgfile = join(["p=",p[i],"alpha=",alpha[j],"2.pdf"])
#         if j == 1 # plotting the first alpha
#             tt = join(["p = ",p[i]])
#             Plots.title!(tt)
#         end
#         if i == 1
#             jj = join(["alpha = ",alpha[j]])
#             Plots.ylabel!(jj)
#         end
            
        PyPlot.gcf()[:set_size_inches](3,2.5)
        PyPlot.gca()[:yaxis][:grid](color="lightgray", linestyle="solid", linewidth=0.4)
        PyPlot.gca()[:xaxis][:grid](color="lightgray", linestyle="solid", linewidth=0.4)
        savefig(imgfile)
        close()
    end
end