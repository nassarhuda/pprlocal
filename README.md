# pprlocal
Code used for "Strong Localization in Personalized PageRank Vectors"

# Before using this code:
This code uses:
- bisquik-julia-wrapper at https://github.com/nassarhuda/bisquik-julia-wrapper
make sure to follow all the steps mentioned its readme file and specifically test the function "create_graph.jl" with the dummy data present in the readme file.
- MatrixNetworks which is a julia package at https://github.com/nassarhuda/MatrixNetworks.jl
make sure install the package as instructed in its readme file and type:
```
using MatrixNetworks
```

#To use this code:
cd to the pprlocal directory and from julia"
```
include("generate_graph_script_v2.jl")
n = 10^4;
p = 0.5;
NNZEROS = generate_graph_script_v2(n,p)
```