# To reproduce the results in the paper:

*** Note: most of these scripts rely on the data being pregenerated. Some of this data is provided in this repo. All data can be generated and instructions to do so are provided here.

### Figure 2
*   Obtain the datasets from SNAP repository, and put them in the directory `real-world-experiments/data/`
*   Run `generate_deg_seq_plots.m` from `real-world-experiments/degree-sequences/`

### Table 2:
*   Run `generate_tab_of_deg_seq.m` from `real-world-experiments/degree-sequences/`

### Figure 3
*   Obtain data by: `include("runscript_BK.jl")` and then `runscript_BK(n)`. If you want to generate the same exact results you need the size of the graph `n = 10^9`. If you want to generate a toy example, you can start with `n = 10^4`
*   Plot data by: `include("plot_bound.jl")` and then `plot_bound(n)`. Choose n to be the same value you choose for data generation.

### Figure 4
*   Obtain data by: `include("instances_experiment.jl")` and then `instances_experiment(n)`. If you want to generate the same exact results you need the size of the graph `n = 10^7`. If you want to generate a toy example, you can start with `n = 10^4`
*   Plot data by: `include("plot_instances_results.jl")` and then `plot_instances_results(n,p,alpha)`. Choose n to be the same value you choose for data generation. p is the decay exponent. alpha is the PageRank teleportaion value. Leftmost figure uses p = 0.5 and alpha = 0.25

### Figure 5
*   Obtain data by: `include("runscript_CL.jl")` and then `runscript_CL(n)`. If you want to generate the same exact results you need the size of the graph `n = 10^7`. If you want to generate a toy example, you can start with `n = 10^4`
*   Plot data by: `include("CL_BK_comparison.jl")` and then `CL_BK_comparison(n,p,alpha)`. Choose n to be the same value you choose for data generation. p is the decay exponent. alpha is the PageRank teleportaion value. Leftmost figure uses p = 0.5 and alpha = 0.25

### Figure 6
*   Generate the results by running `youtube_pagerank.m` and `youtube_synthetic_pagerank.m` from `real-world-experiments/youtube-localization/`
*   Make the plots by running `plotting_synthetic_youtube.m` from `real-world-experiments/youtube_localization/`

### Figure 7:

*   (left): include("smallgraph.jl")
*   (right): Code used to generate the data is in wheel.jl (user can choose to rerun in case they have enough RAM)
``
cd("BK_1e9/")
include("BK_wheel_1e9.jl")
cd("..")
``

### Figure 8
*   Note that this data has been pregenerated via `include("store_nnz.jl")`
*   Run `include("analyze_localization.jl")`

### Figure 9
*   Run `include("battle_of_norms.jl")` and then `battle_of_norms(n,p,alpha)`. As an example, run `battle_of_norms(10^4,0.95,0.85)`

