"""
* `df`: dataframe of results
* `metric`: name of metric, such as :ess for effective sample size
* `group`: a tuple of grouping factors, e.g. (:sampler,:Nd)
* `save`: save=true saves each plot
* `figfmt`: figure format
* `dir`: directory of saved plot. Default pwd.
"""
function plotdensity(df::DataFrame,metric::Symbol,group=(:sampler,);save=false,
    figfmt="pdf",dir="",options...)
    plots = Plots.Plot[]
    layout = SetLayout(df,group)
    grouping = map(x->df[x],group)
    for c in names(df)
        !isin(metric,c) ? (continue) : nothing
        p=density(df[c],group=grouping,grid=false,xlabel=string(c),
            ylabel="Density",layout=layout,fill=(0,.5),width=1.5;options...)
        push!(plots,p)
        save ? savefig(p,string(dir,"density_",c,".",figfmt)) : nothing
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

"""
* `df`: dataframe of results
* `xvar`: variable assigned to x-axis
* `metric`: name of metric, such as :ess for effective sample size
* `group`: a tuple of grouping factors, e.g. (:sampler,:Nd)
* `save`: save=true saves each plot
* `figfmt`: figure format
* func: a function used to summarize results. Default mean
* `dir`: directory of saved plot. Default pwd.
"""
function plotsummary(df::DataFrame,xvar::Symbol,metric::Symbol,group=(:sampler,);save=false,
    figfmt="pdf",func=mean,dir="",options...)
    plots = Plots.Plot[]
    layout = SetLayout(df,group)
    for c in names(df)
        !isin(metric,c) ? (continue) : nothing
        summary,yvar = summarize(df,c,[xvar,group...],func)
        grouping = map(x->summary[x],group)
        p=plot(summary[xvar],summary[yvar],group=grouping,grid=false,xlabel=string(xvar),
            ylabel=string(yvar),layout=layout,width=1.5;options...)
        push!(plots,p)
        save ? savefig(p,string(dir,"summary_",c,".",figfmt)) : nothing
    end
    return plots
end

function summarize(df,metric,grouping,func)
    newDF= by(df,grouping,metric=>func)
    yvar = names(newDF)[end]
    return newDF,yvar
end

"""
* `df`: dataframe of results
* `xvar`: variable assigned to x-axis
* `metric`: name of metric, such as :ess for effective sample size
* `group`: a tuple of grouping factors, e.g. (:sampler,:Nd)
* `save`: save=true saves each plot
* `figfmt`: figure format
* func: a function used to summarize results. Default mean
* `dir`: directory of saved plot. Default pwd.
"""
function plotscatter(df::DataFrame,xvar::Symbol,metric::Symbol,group=(:sampler,);save=false,
    figfmt="pdf",func=mean,dir="",options...)
    plots = Plots.Plot[]
    layout = SetLayout(df,group)
    grouping = map(x->df[x],group)
    for c in names(df)
        !isin(metric,c) ? (continue) : nothing
        p=scatter(df[xvar],df[c],group=grouping,grid=false,xlabel=string(xvar),
            ylabel=string(c),layout=layout,width=1.5;options...)
        push!(plots,p)
        save ? savefig(p,string(dir,"scatter_",xvar,"_",c,".",figfmt)) : nothing
    end
    return plots
end

"""
Generate plot to assess parameter recovery
* `df`: dataframe of results
* `parms`: namedtuple of parameter names and true values
* `group`: a tuple of grouping factors, e.g. (:sampler,:Nd)
* `save`: save=true saves each plot
* `figfmt`: figure format
* func: a function used to summarize results. Default mean
* `dir`: directory of saved plot. Default pwd.
"""
function plotrecovery(df::DataFrame,parms,group=(:sampler,);save=false,
    figfmt="pdf",dir="",options...)
    plots = Plots.Plot[]
    layout = SetLayout(df,group)
    grouping = map(x->df[x],group)
    for (parm,v) in pairs(parms)
        μ = df[Symbol(string(parm,"_mean"))]
        lb = μ .- df[Symbol(string(parm,"_hdp_lb"))]
        ub = df[Symbol(string(parm,"_hdp_ub"))] .- μ
        p=scatter(μ,group=grouping,grid=false,ylabel=string(parm),layout=layout,
            leg=false,yerror=(lb,ub),width=1.5;options...)
        cnt = 0
        [hline!(p,[v],subplot=cnt+=1) for i in 1:layout[1] for j in 1:layout[2]]
        push!(plots,p)
        save ? savefig(p,string(dir,"recovery_",p,".",figfmt)) : nothing
    end
    return plots
end
