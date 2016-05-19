using NPZ

FT = npzread("src_dst_n7.0_p0.95.npz");
src = FT[:,1];
dst = FT[:,2];
FT = 0;
gc();
n = 10^7;
A = sparse(src,dst,1,n,n);

degs = npzread("degs_n7.0_p0.95.npz");
delta = 2;

alpha = 0.85
eps = 10.0^(-4)
n = 10^7
K = round(Int,floor(log(1/eps)/log(1/alpha)))
neighbors = zeros(Int64,K)
smallnodes = zeros(Int64,K)
v = zeros(Int64,n)
v[1] = 1
x = zeros(Int64,n)
x[1] = 1
for i = 1:K
    v = A*v
    x = x+v
    neighbor_ids = find(x)
    neighbors[i] = length(neighbor_ids)
    dn = degs[neighbor_ids]
    smallnodes[i] = length(find(dn .> delta))
end

Plots.plot(neighbors,w=1.25)
Plots.plot!(smallnodes,w=1.25,ylims=(1,n))
Plots.xaxis!("\$k^{th}\$ order neighborhood")
Plots.yaxis!(:log10,"number of nodes present")
PyPlot.gcf()[:set_size_inches](3.5,3)
PyPlot.gca()[:yaxis][:grid](color="lightgray", linestyle="solid", linewidth=0.4)
PyPlot.gca()[:xaxis][:grid](color="lightgray", linestyle="solid", linewidth=0.4)

imgfile = "wheel.pdf"
savefig(imgfile)
close()