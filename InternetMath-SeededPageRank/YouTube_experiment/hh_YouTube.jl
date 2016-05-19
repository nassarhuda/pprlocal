using MatrixNetworks
function havel_hakimi_YouTube(n::Int64,dmax::Int64,dmin::Int64,d)
    
    if mod(sum(d),2) != 0
        d[end] = d[end]+1
    end
    
    @assert all(d .>= 0)
    nedges = sum(d)
    src = zeros(Int,div(nedges,2))
    dst = zeros(Int,div(nedges,2))
    curredge = 1
    
    R = IntSet([])
    V = [IntSet([])]
    for i = 2: dmax
        push!(V,IntSet([]))
    end
    
    W = [IntSet([])]
    for i = 2: dmax
        push!(W,IntSet([]))
    end
    
    for i = 1:length(d)
        push!(V[d[i]],i)
    end
    
    for i = dmax:-1:1
        println("i is $i")
        v = V[i]
        degval = i
        while !isempty(v)
            k = 1
            s = pop!(v)
            src[curredge:curredge+degval-1] = s
            curraddition = 0
            
            while !isempty(v) && curraddition < degval
                q = pop!(v)
                dst[curredge+curraddition] = q
                if i-k > 0
                    push!(W[i-k],q)
                    push!(R,i-k)
                end
                curraddition += 1
            end
            
            while curraddition < degval
                w = V[i-k]
                k += 1
                while !isempty(w) && curraddition < degval
                    q = pop!(w)
                    dst[curredge+curraddition] = q
                    if i-k > 0
                        push!(W[i-k],q)
                        push!(R,i-k)
                    end
                    curraddition += 1
                end
                if i-k >0
                    w = V[i-k]
                end
            end
            
            # after it's done
            while !isempty(R)
                c = pop!(R)
                h = W[c]
                while !isempty(h)
                    x = pop!(h)
                    push!(V[c],x)
                end
            end
            curredge = curredge + degval
        end
    end
    A = sparse(src,dst,1,n,n)
    println("A = sparse(src,dst,1,n,n) done")
    
    
    V = 0
    W = 0
    R = 0
    gc()
    
    A = spones(A+A')
    println("A = spones(A+A') done")
    println("A is created")
    

    println("scomponents check is starting")
    cc = scomponents(A)
    lcc = cc.sizes[1]
    println("lcc is $lcc")
    if lcc < n*(1 - 10.0^-3)
        error("Largest connected component is too small")
    end
    A = 0
    gc()
    srcn = [src;dst]
    dstn = [dst;src]
    src = 0
    dst = 0
    gc()
    return (srcn,dstn,d)
end