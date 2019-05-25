"""
Convert DynamcHMC samples to a chain
* `posterior`: an array of NamedTuple consisting of mcmcm samples
"""
function nptochain(posterior)
    Np = length(vcat(posterior[1]...))
    Ns = length(posterior)
    a3d = Array{Float64,3}(undef,Ns,Np,1)
    for (i,post) in enumerate(posterior)
        temp = Float64[]
        for p in post
            push!(temp,values(p)...)
        end
        a3d[i,:,1] = temp'
    end
    parameter_names = getnames(posterior)
    chns = MCMCChains.Chains(a3d,parameter_names,
    Dict(
        :parameters => parameter_names,
        )
    )
    return chns
end

function getnames(post)
    nt = post[1]
    Np =length(vcat(nt...))
    parm_names = fill("",Np)
    cnt = 0
    for (k,v) in pairs(nt)
        N = length(v)
        if N > 1
            for i in 1:N
                cnt += 1
                parm_names[cnt] = string(k,"[",i,"]")
            end
        else
            cnt+=1
            parm_names[cnt] = string(k)
        end
    end
    return parm_names
end

function setprocs(n)
    np = nprocs()-1
    m = max(n-np,0)
    addprocs(m)
end