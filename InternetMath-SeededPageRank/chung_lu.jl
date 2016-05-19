using MatrixNetworks
include("degseq.jl")
function chung_lu(p::Float64,n::Int64,dmax::Int64,dmin::Int64)
    d = convert(Array{Int64,1},ceil(degseq(p,n,dmax,dmin)))
    
    if mod(sum(d),2) != 0
        d[end] = d[end]+1
    end

####################################

    nedges = sum(d)
    nodevec = zeros(Int,nedges)
    curedge = 1
    
    for i=1:n
        for j=1:d[i]
            nodevec[curedge] = i
            curedge += 1
        end
    end
    
    src = rand(nodevec,div(nedges,2))
    dst = rand(nodevec,div(nedges,2))

####################################
    

    
    println("src and dst are created")
    
    A = sparse(src,dst,1,n,n)
    println("A = sparse(src,dst,1,n,n) done")
    

    nodevec = 0
    d = 0
    gc()
    
    A = spones(A+A')
    println("A = spones(A+A') done")
    A = A - spdiagm(diag(A))
    println("A = A - spdiagm(diag(A)) done")
    println("A is created")
    
    deg = sum(A,2)
    println("scomponents check is starting")

    return (A,deg,src,dst)

end
