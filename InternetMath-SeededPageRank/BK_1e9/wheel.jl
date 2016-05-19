using NPZ

FT = npzread("src_dst_n9.0_p0.95.npz");
src = FT[:,1];
dst = FT[:,2];
FT = 0;
gc();
n = 10^9;
A = sparse(src,dst,1,n,n);

degs = npzread("degs_n9.0_p0.95.npz");
delta = 2;

alpha = 0.85
eps = 10.0^(-4)
K = round(Int,floor(log(1/eps)/log(1/alpha)))
neighbors = zeros(Int64,K)
largenodes = zeros(Int64,K)
v = zeros(Int64,n)
v[1] = 1
x = zeros(Int64,n)
x[1] = 1
for i = 1:K
    println("i is $i")
    v = A*v
    x = x+v
    neighbor_ids = find(x)
    neighbors[i] = length(neighbor_ids)
    dn = degs[neighbor_ids]
    largenodes[i] = length(find(dn .> delta))
end

npzwrite("largenodes.npz",largenodes)
npzwrite("neighbors.npz",neighbors)