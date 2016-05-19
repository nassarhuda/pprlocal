# input is src,dst,degs,n
# this implementation is very "unclean"
# it is done this way because we were running multiple experiments on very large graphs
# and wanted them to finish fast - this approach consumed the less RAM than other approaches
# and thus we were able to run different experiments to together
# please check solve_local_PageRank2.jl for a better implementation

function solve_local_PageRank3(P,n,p,gga,N)
    alpha = [0.25 0.3 0.5 0.65 0.85]
    
    S = zeros(Float64,n)
    S[1] = 1
    
    err = 1e-12

    iter_val = zeros(Int64,length(alpha)+1)
    iter_val[1] = 0
    for i  = 1:length(alpha)
       iter_val[i+1] = round(Int,((log(err/2))/(log(alpha[i]))))
    end
    
    X1 = zeros(Float64,n)
    X2 = zeros(Float64,n)
    X3 = zeros(Float64,n)
    X4 = zeros(Float64,n)
    X5 = zeros(Float64,n)
    
    X1[1,:] = 1
    X2[1,:] = 1
    X3[1,:] = 1
    X4[1,:] = 1
    X5[1,:] = 1
    
    alpha1 = alpha[1]
    alpha2 = alpha[2]
    alpha3 = alpha[3]
    alpha4 = alpha[4]
    alpha5 = alpha[5]
    
    # X is the solution vector
    
    alpha_power = 0
    for i = iter_val[1]+1:iter_val[2]
        println("i is $i")
        S = P*S
        alpha_power += 1
        X1 = (alpha1^alpha_power)*S + X1
        X2 = (alpha2^alpha_power)*S + X2
        X3 = (alpha3^alpha_power)*S + X3
        X4 = (alpha4^alpha_power)*S + X4
        X5 = (alpha5^alpha_power)*S + X5
    end
    
    X1 = (1-alpha1) * X1
    datafile = join([gga;"_PR_sln";log10(N);"_p";p;"_alpha";alpha1;".npz"])
    npzwrite(datafile,X1)
    X1 = 0
    gc()
    
    for i = iter_val[2]+1:iter_val[3]
        println("i is $i")
        S = P*S
        alpha_power += 1
        X2 = (alpha2^alpha_power)*S + X2
        X3 = (alpha3^alpha_power)*S + X3
        X4 = (alpha4^alpha_power)*S + X4
        X5 = (alpha5^alpha_power)*S + X5
    end
    
    X2 = (1-alpha2) * X2
    datafile = join([gga;"_PR_sln";log10(N);"_p";p;"_alpha";alpha2;".npz"])
    npzwrite(datafile,X2)
    X2 = 0
    gc()
    
    for i = iter_val[3]+1:iter_val[4]
        println("i is $i")
        S = P*S
        alpha_power += 1
        X3 = (alpha3^alpha_power)*S + X3
        X4 = (alpha4^alpha_power)*S + X4
        X5 = (alpha5^alpha_power)*S + X5
    end
    
    X3 = (1-alpha3) * X3
    datafile = join([gga;"_PR_sln";log10(N);"_p";p;"_alpha";alpha3;".npz"])
    npzwrite(datafile,X3)
    X3 = 0
    gc()
    
    for i = iter_val[4]+1:iter_val[5]
        println("i is $i")
        S = P*S
        alpha_power += 1
        X4 = (alpha4^alpha_power)*S + X4
        X5 = (alpha5^alpha_power)*S + X5
    end
    
    X4 = (1-alpha4) * X4
    datafile = join([gga;"_PR_sln";log10(N);"_p";p;"_alpha";alpha4;".npz"])
    npzwrite(datafile,X4)
    X4 = 0
    gc()
    
    for i = iter_val[5]+1:iter_val[6]
        println("i is $i")
        S = P*S
        alpha_power += 1
        X5 = (alpha5^alpha_power)*S + X5
    end
    
    X5 = (1-alpha5) * X5
    datafile = join([gga;"_PR_sln";log10(N);"_p";p;"_alpha";alpha5;".npz"])
    npzwrite(datafile,X5)
    X5 = 0
    gc()
    
end
