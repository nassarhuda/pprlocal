#splitted pagerank to pagerank_solver_v2 and prepagerank

include("pagerank_solver_v2.jl")
include("pre_pagerank_solver.jl")
function generate_graph_script_v2(n::Int64,p::Float64)
    tStart=time()
    #####################################################
    d = floor(n.^(1/2))
    delta = 2 # min degree
    p = 0.5 # power law
    
    # epsilon accuracy:
    eps_accuracy = [1e-1, 1e-2, 1e-3, 1e-4]
    # alpha values:
    alpha = [0.25 0.3 0.5 0.65 0.85]
    
    #####################################################
    # count the number of nonzeros:
    
    k = 1 # number of vectors to pick
    NNZEROS = zeros(Int64,length(eps_accuracy),length(alpha),length(n))
    for exp_id = 1:length(n)
        
        A = create_graph(p,int(n[exp_id]),int(d[exp_id]),delta)
        cc = scomponents(A)
        lcc = cc.sizes[1]
        if lcc > n*(1 - 10^-4)
            error("Largest connected component is too small")
        end
        (P,V) = pre_pagerank_solver(A)
        for alpha_id = 1:length(alpha)
            X = pagerank_solver_v2(P,V,alpha[alpha_id])
            X_sorted = sort(X,1)
            
            for i = 1:length(eps_accuracy)
            t = 0
            for c = 1:k
                vsum = cumsum(X_sorted[:,c])
                temp = find(vsum .< eps_accuracy[i])
                index = temp[end]
                t = t + index
            end
            # get the average of non zeros among k vectors
            NNZEROS[i,alpha_id,exp_id] = (k*n[exp_id] - t)/k
            end
        end
    end
    

    #fname = join(["nnzvals",".csv"])
    #writecsv(fname, NNZEROS)
    #@printf("Experiment is over, saving to %s\n",fname)
    return NNZEROS
end