using StatsPlots,DataFrames
gr()

"""
`df`: dataframe of results
`metric`: name of metric, such as :ess for effective sample size
`group`: a tuple of grouping factors, e.g. (:sampler,:Nd)
`save`: save=true saves each plot
`figfmt`: figure format
"""
function plotdensity(df::DataFrame,metric::Symbol,group=(:sampler,);save=false,
    figfmt="pdf",options...)
    plots = Plots.Plot[]
    layout = SetLayout(df,group)
    println((group))
    for c in names(df)
        !isin(metric,c) ? (continue) : nothing
        xlabel = string(c)
        p=@df df density(cols(c),group=cols(group),grid=false,xlabel=xlabel,
            ylabel="Density",layout=layout,fill=(0,.5),width=1.5,options...)
        push!(plots,p)
        save ? savefig(p,string(c,".",figfmt)) : nothing
    end
    return plots
end

"""
Test whether column is a metric, e.g. mu_ess for ess.
"""
function isin(metric,col)
    occursin(string(metric),string(col))
end

"""
Creates a layout = (n,1) where n is the number of factors
in the last grouping variable.
"""
function SetLayout(df,group)
    isempty(group) ? (return (1,1)) : nothing
    length(group) == 1 ? (return (1,1)) : nothing
    col = group[end]
    n = length(unique(df[col]))
    return (n,1)
end

ProjDir=@__DIR__
cd(ProjDir)
isfile("test_cols.pdf") && rm("test_cols.pdf")
df = DataFrame(mu_ess=rand(100),sigma_ess=rand(100),a=rand(1:2,100),b=rand(1:2,100))
plotdensity(df,:ess,(:a, :b))
savefig("test_cols.pdf")