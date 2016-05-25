if OS_NAME == :Linux
    const libpath = string(pwd(), "/libbisquik.so")
else
    const libpath = string(pwd(), "/libbisquik.dylib")
end
using MatrixNetworks
include("degseq.jl")
function bisquik_graph(degs::Array{Int64},trials::Int64,n::Int64)
    trial_number = 1
    @printf("trial number: %i\n",trial_number)
    check_flag = ccall ( (:check_graphical_sequence, libpath),
                        Cint, # return value
                        (Int64, Ptr{Int64}), # arg types
                        n, degs); # actual args
    trial_number = 2
    while trial_number <= trials && check_flag == 0
        @printf("trial number: %i\n",trial_number)
        degs[end] += 1
        if mod(sum(degs),2) != 0
            degs[end] = degs[end]+1
        end
        check_flag = ccall ( (:check_graphical_sequence, libpath),
                        Cint, # return value
                        (Int64, Ptr{Int64}), # arg types
                        n, degs) # actual args
        trial_number = trial_number + 1
	end
	
	if check_flag == 1
	    @printf("Successfully generated a graphical sequence.\n")
        nedges = sum(degs)
        src = zeros(Int64, nedges)
        dst = zeros(Int64, nedges)
        rval = ccall ( (:generate_bisquik_graph, libpath),
                        Cint, # return value
                        (Int64, Ptr{Int64}, Ptr{Int64}, Ptr{Int64}), # arg types
                        length(degs), degs, src, dst) # actual args
        src = src+1
        dst = dst+1
        @printf("Successfully generated graph.\n")
    else
   		@printf("COULD NOT GENERATE A GRAPHICAL SEQUENCE\n")
		###############################
		#TODO: improve this error case#
		###############################
		assert(false);
    end

    l = length(degs)
    return (src,dst,l)
end

function check_graphical_sequence(degs::Array{Int64},trials::Int64,n::Int64)
    trial_number = 1
    @printf("trial number: %i\n",trial_number)
    check_flag = ccall ( (:check_graphical_sequence, libpath),
                        Cint, # return value
                        (Int64, Ptr{Int64}), # arg types
                        n, degs) # actual args
    trial_number = 2
    while trial_number <= trials && check_flag == 0
        @printf("trial number: %i\n",trial_number)
        degs[end] += 1
        if mod(sum(degs),2) != 0
            degs[end] = degs[end]+1
        end
        check_flag = ccall ( (:check_graphical_sequence, libpath),
                        Cint, # return value
                        (Int64, Ptr{Int64}), # arg types
                        n, degs) # actual args
        trial_number = trial_number + 1
    end
    return (degs,check_flag)
end


function create_graph(p::Float64,n::Int64,dmax::Int64,dmin::Int64)
	n = round(Int,n)
   	trials = 5
	degs_vector = convert(Array{Int64,1},ceil(degseq(p,n,dmax,dmin)))
	(src,dst,l) = bisquik_graph(degs_vector,trials,n)
	A = sparse(src,dst,1,n,n)
	println("scomponents check is starting")
	cc = scomponents(A)
    lcc = cc.sizes[1]
    println("lcc is $lcc")
    if lcc < n*(0.95)
        error("Largest connected component is too small")
    end
    A = 0
    gc()
	return (src,dst,degs_vector)
end