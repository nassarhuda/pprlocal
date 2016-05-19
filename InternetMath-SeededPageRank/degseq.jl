function degseq(p::Float64,n::Int64,dmax::Int64,dmin::Int64)
    last = round(Int,floor((dmin/dmax)^(-1/p)))
    v = ones(Int64,n)
    v = v.*dmin
    
    for k = 1:last
        v[k] = ceil(dmax/(k^p))
    end
    return v
end