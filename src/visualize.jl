





function prepare_dictionary(names::Vector{Symbol})
    d = Dict{Symbol, Vector{Float64}}()
    for name in names
        d[name] = Vector{Float64}()
    end
    return d
end

function clock_collect(names::Vector{Symbol}, dates::Matrix{Float64})
    d = prepare_dictionary(names)
    l = length(names)
    for i = 1:l, j = i+1:l
        push!(d[names[i]], dates[i, j])
        push!(d[names[j]], dates[i, j])
    end
    return d
end

#using Plots; gr(); sticks(linspace(0.25π,1.5π,5), rand(5), proj=:polar, yerr=.1)
