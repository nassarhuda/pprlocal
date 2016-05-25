include("create_graph_funcs.jl")
n = 100
dmax = 10
dmin = 2
p = 0.95
(src,dst,degs) = create_graph(p,n,dmax,dmin)
A = sparse(src,dst,1,n,n);

using PyCall
@pyimport igraph

function igraph_layout{T}(A::SparseMatrixCSC{T}, layoutname::AbstractString="lgl")
    (ei,ej) = findnz(A)
    edgelist = [(ei[i]-1,ej[i]-1) for i = 1:length(ei)]
    nverts = size(A)
    G = igraph.Graph(nverts, edges=edgelist, directed=true)
    layoutname = "fr"
    xy = G[:layout](layoutname)
    xy = [ Float64(xy[i][j]) for i in 1:length(xy),  j in 1:length(xy[1])]
end

xy = igraph_layout(A);
using PyPlot

function graphplot(A,xy)
    (ei,ej) = findnz(triu(A))
    lx = [xy[ei,1]';xy[ej,1]';NaN*ones(1,length(ei))]
    ly = [xy[ei,2]';xy[ej,2]';NaN*ones(1,length(ei))]
    lines = PyPlot.plot(lx,ly)
    PyPlot.axis("off")
    PyPlot.setp(lines,alpha=0.5,color=[0.,0.,0.],zorder=0)
end

graphplot(A,xy)
PyPlot.scatter(xy[:,1],xy[:,2],12,edgecolors="none",zorder=2)
savefig("hundred_nodes_graph.pdf")
close()