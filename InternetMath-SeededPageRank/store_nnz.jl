using NPZ
default(guidefont = font(40), tickfont = font(15))
total_number_of_instances = 5
p = [0.5;0.75;0.95]
alpha = [0.25;0.3;0.5;0.65;0.85]
delta = 2
w = 1:0.2:4
eps_accuracy = 10.^(-w)
N = 10^9
e = 9
eps_accuracy_reciprocal = 1./eps_accuracy
AN = zeros(Float64,length(p),length(alpha),length(eps_accuracy))
AN2 = zeros(Float64,length(p),length(alpha),length(eps_accuracy))
Bp = zeros(Float64,length(p),length(alpha),length(eps_accuracy))
for i = 1:length(p)
    println("p val is $p")
    dfile = join(["BK_1e",e,"/degs_n",log10(N),"_p",p[i],".npz"])
    degs = npzread(dfile)
    dmax = degs[1]
    Cp = dmax*(1+(1/(1-p[i]))*(dmax^((1/p[i])-1)-1))
    degs = 0

    gc()
    for j = 1:length(alpha)
        file = join(["BK_1e",e,"/BK_PR_sln",log10(N),"_p",p[i],"_alpha",alpha[j],".npz"])
        X = npzread(file)
        n = length(X)
        X_sorted = sort(X)
        vsum = cumsum(X_sorted)
        for h = 1:length(eps_accuracy)
            index = findlast(vsum .< eps_accuracy[h])
            AN[i,j,h] = n - index
            Bp[i,j,h] = 1 + dmax + (1/(delta-1))*Cp*((alpha[j]^2/eps_accuracy[h])^((delta-1)/(1-alpha[j])))
        end
    end
end

BKNNZ = join(["BK_NNZ_n=",N,".npz"])
npzwrite(BKNNZ,AN)
BOUND = join(["BOUND_n=",N,".npz"])
npzwrite(BOUND,Bp)