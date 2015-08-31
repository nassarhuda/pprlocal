# pprlocal
Code used for "Strong Localization in Personalized PageRank Vectors"

# Before using this code:
This code uses:
- bisquik-julia-wrapper at https://github.com/nassarhuda/bisquik-julia-wrapper
make sure to follow all the steps mentioned in its readme file and specifically test the function "create_graph.jl" with the dummy data present in the readme file.
Note: It is advisable to save the pprlocal folder as a subfolder under bisquik-julia-wrapper
- MatrixNetworks which is a julia package at https://github.com/nassarhuda/MatrixNetworks.jl
make sure to install the package as instructed in its readme file and type:
```
using MatrixNetworks
```

#To use this code:
cd to the pprlocal directory and from julia
```
include("generate_graph_script_v2.jl")
n = 10^4;
p = 0.5;
NNZEROS = generate_graph_script_v2(n,p)
```
