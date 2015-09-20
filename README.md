# pprlocal
Code used for "Strong Localization in Personalized PageRank Vectors"

# Before using this code:
This code uses:
- bisquik-julia-wrapper at https://github.com/nassarhuda/bisquik-julia-wrapper
make sure to follow all the steps mentioned in its readme file and specifically test the function create_graph() with the example present in its README file.   
Note on file paths: Code in this repo uses code from bisquik-julia-wrapper. You can choose to manage the paths as you wish if you know what you're doing but as an alternative you can save the julia files of this repo in the folder bisquik-julia-wrapper (or bisquik-julia-wrapper-master depending on the name of your folder)
- MatrixNetworks which is a julia package at https://github.com/nassarhuda/MatrixNetworks.jl
make sure to install the package as instructed in its README file and type:
```
using MatrixNetworks
```

#To use this code:
cd to the pprlocal directory and from julia
```
include("create_graph_funcs.jl")
include("generate_graph_script_v2.jl")
n = 10^4;
p = 0.5;
NNZEROS = generate_graph_script_v2(n,p)
```

NNZEROS[i,j] = number of nonzeros of a graph of size n with power-law degree distribution p and at epsilon_accuracy = eps_values[i] and PageRank problem solved with alpha = alpha_values[j]   
where eps_values = [1e-1, 1e-2, 1e-3, 1e-4]   
and alpha_values = [0.25, 0.3, 0.5, 0.65, 0.85]