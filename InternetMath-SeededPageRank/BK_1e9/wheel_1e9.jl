#wheel 1e9

using NPZ
using Plots
n = 10^9
neighbors = npzread("neighbors.npz")
largenodes = npzread("largenodes.npz")

pyplot()

Plots.plot(neighbors,w=1.25)
Plots.plot!(largenodes,w=1.25,ylims=(1,n))
Plots.xaxis!("\$k^{th}\$ order neighborhood")
Plots.yaxis!(:log10,"number of nodes present")
PyPlot.gcf()[:set_size_inches](3.5,3)
PyPlot.gca()[:yaxis][:grid](color="lightgray", linestyle="solid", linewidth=0.4)
PyPlot.gca()[:xaxis][:grid](color="lightgray", linestyle="solid", linewidth=0.4)

imgfile = "wheel.pdf"
savefig(imgfile)
close()