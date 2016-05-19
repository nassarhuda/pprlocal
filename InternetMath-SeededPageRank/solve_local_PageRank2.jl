# input is src,dst,degs,n

using MatrixNetworks
function solve_local_PageRank2(src,dst,degs,n,p)
    alpha = [0.25 0.3 0.5 0.65 0.85]
    
    P = sparse(src,dst,1./degs[dst],n,n)
    
    println("XXX finished P")
    src = 0
    dst = 0
    degs = 0
    gc()
    
    S = zeros(Float64,n)
    S[1] = 1
    
    err = 1e-12

    iter_val = zeros(Int64,length(alpha)+1)
    iter_val[1] = 0
    for i  = 1:length(alpha)
       iter_val[i+1] = round(Int,((log(err/2))/(log(alpha[i]))))
    end
    
    X = zeros(Float64,n,length(alpha))
    X[1,:] = 1
    
    alpha_power = 0
    for alpha_id = 1:length(alpha)
        for i = iter_val[alpha_id]+1:iter_val[alpha_id+1]
            S = P*S
            alpha_power += 1
            for j = alpha_id:length(alpha)
                X[:,j] = ((alpha[j])^alpha_power)*S + X[:,j]
            end
        end
    end
    
    for i = 1:length(alpha)
        X[:,i] = (1-alpha[i]) * X[:,i]
        datafile = join(["PR_sln",log10(n),"_p",p,"_alpha",alpha[i],".npz"])
        npzwrite(datafile,X[:,i])
    end
    
end
