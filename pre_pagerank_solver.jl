function pre_pagerank_solver(A::SparseMatrixCSC{Int64,Int64})
    # k is the number of vectors in the experiment
    # we're just picking one now
    # Generate transition matrix P
    n = size(A,1)
    s = sum(A,2)
    
    #idx = 1:n
    #vals = 1./s
    #@time begin
    #P = sparse(idx, idx, vals[:])*A;
    #end
    #@time begin
    #k = length(A.rowval);
    #for i = 1:k
    #    A.nzval[i] = A.nzval[i] * vals[A.rowval[i]]
    #end
    #end;
    
    (ei,ej) = findnz(A)
    P = sparse(ei,ej,1./s[ei],size(A,1),size(A,2))
    
    # pick the k vectors to work with:
    # ids = int(1 + floor(rand(k)*n))
    # this is only working when k = 1
    
    # not getting the max since here the max is always the first vector, that's how we construct degs_vector
    #(mx,id) = findmax(s)
    
    V = zeros(Float64,n)
    V[1] = 1
    return (P,V)

end