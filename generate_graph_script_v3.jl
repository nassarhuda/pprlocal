#splitted pagerank to pagerank_solver_v2 and prepagerank
#running it for 10 experiments (10 graphs)

include("create_graph.jl")
include("pagerank_solver_v2.jl")
include("pagerank_solver_v3.jl")
include("pre_pagerank_solver_v2.jl")
include("degseq.jl")
#Pkg.add("Gadfly")
#Pkg.add("MAT")
using MAT
function generate_graph_script_v3(p::Float64)

    #####################################################
    # This is based on pagerank_solution_nonzeros_v3.m
    n = [10^4,10^5,10^6,10^7]#[10^6,10^7]#[10^8,10^9]#[10^6]#[10^4,10^5]#
    d = floor(n.^(1/2))
    delta = 2 # min degree
    # p = 0.5 # power law

    # epsilon accuracy:
    eps_accuracy = [1e-1, 1e-2, 1e-3, 1e-4]
    # alpha values:
    alpha = [0.25 0.3 0.5 0.65 0.85]

    #####################################################
    # count the number of nonzeros:

    graphs_experiments = 5;
    trials = 5;
    k = 1 # number of vectors to pick
    NNZEROS = zeros(Int64, graphs_experiments*length(eps_accuracy),length(alpha),length(n))
    deg_vec = ones(Int64,n[1])
    nedges = sum(deg_vec)
    src_vec = zeros(Int64, nedges)
    dst_vec = zeros(Int64, nedges)
    for exp_id = 1:length(n)
        tStart = time()
        degs_vector = degseq(p,n[exp_id],int(d[exp_id]),delta)
        (degs_vector,check_flag) = check_graphical_sequence(degs_vector,trials,n[exp_id])
        if check_flag == 0
            error("could not generate a graphical sequence")
        else
            @printf("Successfully generated a graphical sequence for n = %i.\n",n[exp_id])
            for graph_id = 1:graphs_experiments
                tStart2 = time()
                srand(graph_id)
                (src,dst) = create_graph(degs_vector,n[exp_id])
                #nzvals = 1./degs_vector[src]
                #V = zeros(Float64,n[exp_id])
                #V[1] = 1
                (P,V) = pre_pagerank_solver_v2(src,dst,degs_vector)
                for alpha_id = 1:length(alpha)
                    @printf("alpha value = %f started ",alpha[alpha_id])
                    tStart_alpha = time()
                    X = pagerank_solver_v2(P,V,alpha[alpha_id])
                    #X = pagerank_solver_v3(src,dst,nzvals,V,alpha[alpha_id])
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
                        NNZEROS[length(eps_accuracy)*(graph_id-1)+i,alpha_id,exp_id] = (k*n[exp_id] - t)/k
                    end
                    @printf(", time taken is: %f\n",time()-tStart_alpha)
                    #fname = join(["n9_output_", string(p*100),string(alpha[alpha_id]),".csv"])
                end
            @printf("Elapsed time for n = %i, graph_id = %i is %f seconds.\n",n[exp_id],graph_id,time()-tStart2)
            #writecsv(fname, NNZEROS)
            src_vec = src
            dst_vec = dst
            end
            deg_vec = degs_vector
        end
        @printf("Total elapsed time for n = %i is %f seconds.\n",n[exp_id],time()-tStart)
    end

    #fname = join(["nnzvalst",".csv"])
    #writecsv(fname, NNZEROS)
    #@printf("Experiment is over, saving to %s\n",fname)
    filename = matopen("NNZVALS4_7p75.mat","w")
    write(filename,"NNZEROS",NNZEROS)
    close(filename)
    #return (NNZEROS,deg_vec,src_vec,dst_vec)
    return NNZEROS
end


# 
# #splitted pagerank to pagerank_solver_v2 and prepagerank
# #running it for 10 experiments (10 graphs)
# 
# include("create_graph.jl")
# include("pagerank_solver_v2.jl")
# include("pagerank_solver_v3.jl")
# include("pre_pagerank_solver_v2.jl")
# include("degseq.jl")
# #Pkg.add("Gadfly")
# #Pkg.add("MAT")
# using MAT
# function generate_graph_script_v3(p::Float64)
#     
#     #####################################################
#     # This is based on pagerank_solution_nonzeros_v3.m
#     n = [10^4]#[10^8]#[10^4,10^5,10^6,10^7]#[10^8,10^9]#[10^6]#[10^4,10^5]#
#     d = floor(n.^(1/2))
#     delta = 2 # min degree
#     # p = 0.5 # power law
#     
#     # epsilon accuracy:
#     eps_accuracy = [1e-1, 1e-2, 1e-3, 1e-4]
#     # alpha values:
#     alpha = [0.25 0.3 0.5 0.65 0.85]
#     
#     #####################################################
#     # count the number of nonzeros:
#     
#     graphs_experiments = 1;
#     trials = 5;
#     k = 1 # number of vectors to pick
#     NNZEROS = zeros(Int64, graphs_experiments*length(eps_accuracy),length(alpha),length(n))
#     for exp_id = 1:length(n)
#     	tStart = time()
#         degs_vector = degseq(p,n[exp_id],int(d[exp_id]),delta)
#         (degs_vector,check_flag) = check_graphical_sequence(degs_vector,trials,n[exp_id])
#         if check_flag == 0
#             error("could not generate a graphical sequence")
#         else
#             @printf("Successfully generated a graphical sequence for n = %i.\n",n[exp_id])
#             for graph_id = 1:graphs_experiments
#                 tStart2 = time()
#                 srand(graph_id)
#                 (src,dst) = create_graph(degs_vector,n[exp_id])
#                 #nzvals = 1./degs_vector[src]
#                 (P,V) = pre_pagerank_solver_v2(src,dst,degs_vector)
#                 for alpha_id = 1:length(alpha)
#                     @printf("alpha value = %f started ",alpha[alpha_id])
#                     tStart_alpha = time()
#                     X = pagerank_solver_v2(P,V,alpha[alpha_id])
#                     #X = pagerank_solver_v3(src,dst,nzvals,V,alpha[alpha_id])
#                     X_sorted = sort(X,1)
#                     for i = 1:length(eps_accuracy)
#                         t = 0
#                         for c = 1:k
#                             vsum = cumsum(X_sorted[:,c])
#                             temp = find(vsum .< eps_accuracy[i])
#                             index = temp[end]
#                             t = t + index
#                         end
#                         # get the average of non zeros among k vectors
#                         NNZEROS[4*(graph_id-1)+i,alpha_id,exp_id] = (k*n[exp_id] - t)/k
#                     end
#                     @printf(", time taken is: %f\n",time()-tStart_alpha)
#                 end
#             @printf("Elapsed time for n = %i, graph_id = %i is %f seconds.\n",n[exp_id],graph_id,time()-tStart2)
#             end
#         end
#         @printf("Total elapsed time for n = %i is %f seconds.\n",n[exp_id],time()-tStart)
#     end
#     
# #     fname = join(["output", string(p*100),".csv"])
# #     writecsv(fname, NNZEROS)
# #     @printf("Experiment is over, saving to %s\n",fname)
#     filename = matopen("o_ne8p95.mat","w")
#     write(filename,"NNZEROS",NNZEROS)
#     close(filename)
#     return (NNZEROS,deg_vec,src_vec,dst_vec)
# end