# To reproduce the results in the paper:

*** Note: most of these scripts rely on the data being pregenerated, nevertheless, all data needed can be reproduced via runscript_BK.jl
or runscript_CL.jl

### Figure 3:
* to generate the values: runscript_BK.jl --> input is size of the graph n. You can generate a dummy example with n = 10^4 as a start
* to produce the plots: plot_nnz.jl --> it is currently set up with N = 10^4 and e = 4

### Figure 4:
* to generate multiple instances: instances_experiment.jl --> it is already set up with n = 10^7 and total_instances_nb = 5
* to plot the instances: --> BK_1e7_instances/plot_results.jl

### Figure 5:
* code: CL_BK_comparison.jl

### Figure 6:
* YouTube Chung Lu graph: YouTube_experiment/cl_YouTube.jl

### Figure 7:
* data generation: BK_1e9/wheel.jl
* plots: BK_1e9/wheel_1e9.jl
* smallgraph.jl

### Figure 8:
* analyze_localization.jl

### Figure 9:
* battle_of_norms.jl
