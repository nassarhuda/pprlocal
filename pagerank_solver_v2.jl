function trans_mat_vec(A::SparseMatrixCSC{Float64,Int64}, x::Vector{Float64})
  y = zeros(size(A,2))
  cp = A.colptr
  nz = A.nzval
  rv = A.rowval
  n = size(A,2)
  for i=1:n
      yi = 0.
      for nzi=cp[i]:cp[i+1]-1
          yi += nz[nzi]*x[rv[nzi]]
      end
      y[i] = yi
  end
  return y
end


function pagerank_solver_v2(P::SparseMatrixCSC{Float64,Int64},V::Vector{Float64},alpha::Float64)
    ## Solve the PageRank problem using the power method
    X = V
    Vp = (1-alpha)*V

    err = 1e-12
    iters_nb = floor((log(err/2))/(log(alpha)))

    for i = 1:iters_nb
        X = alpha*trans_mat_vec(P,X[:]) + Vp
    end

    return X
end