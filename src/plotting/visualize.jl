
function allowed_units(arg::String)
    larg = lowercase(arg)
    return larg == "inch" || larg == "mm" || larg == "cm"
end

function process_units(arg::String)
    larg = lowercase(arg)
    return larg == "inch" ? inch : larg == "mm" ? mm : larg == "cm" ? cm : error("Invalid units, this should not happen.")
end

function allowed_backend(arg::String)
    larg = lowercase(arg)
    return larg == "svg" || larg == "svgjs" || larg == "png" || larg == "pdf" || larg == "ps" || larg == "pgf"
end

function process_backend(arg::String)
    larg = lowercase(arg)
    if larg == "svg"
        return SVG
    end
    if larg == "svgjs"
        return SVGJS
    end
    if larg == "png"
        return PNG
    end
    if larg == "pdf"
        return PDF
    end
    if larg == "ps"
        return PS
    end
    if larg == "pgf"
        return PGF
    end
end

function is_windowed_data(df::DataFrame)
    ns = names(df)
    return (:WindowFirst ∈ ns) && (:WindowLast ∈ ns)
end

function is_distance_data(df::DataFrame)
    ns = names(df)
    return :Value ∈ ns
end

#=
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
=#

function filter_by_ref(df, ref)
    a = df[:FirstSeq]
    b = df[:SecondSeq]
    idx = [(a[i] == ref) || (b[i] == ref) for i in 1:length(a)]
    return df[idx, :]
end

function sequence_names(df, ref)
    return [df[i, :FirstSeq] != ref ? df[i, :FirstSeq] : df[i, :SecondSeq] for i in 1:nrow(df)]
end

function heatplot_y_order(df, col, bysim)
    level_values = levels(df[:SeqName])
    if bysim
        means = Vector{Float64}(length(level_values))
        vals = Vector{Float64}(df[col])
        m = 1
        for sname in level_values
            idx = df[:SeqName] .== sname
            subvals = vals[idx]
            means[m] = sum(subvals)
            m += 1
        end
        o = sortperm(means)
    else
        o = sortperm(level_values)
    end
    return o
end

function heatplot(df::DataFrame, col::Symbol, legend::String)
    return (plot(df, x = :FirstSeq, y = :SecondSeq, color = col, Geom.rectbin,
                Guide.xlabel("Sequence name"), Guide.ylabel("Sequence name"),
                Guide.colorkey(legend),
                Guide.title("$(legend) between sequences")), df)
end

function heatplot(df::DataFrame, col::Symbol, ref::String, legend::String, sortsim::Bool)
    if ref == "default"
        ref = df[:FirstSeq][1]
    end

    df = filter_by_ref(df, ref)
    df[:RefName] = fill!(Vector{String}(nrow(df)), ref)
    df[:SeqName] = sequence_names(df, ref)
    pool!(df, [:RefName, :SeqName])

    idx = [isnan(i) for i in df[col]]
    df[idx, col] = NA

    complete_df = df[complete_cases(df), :]

    o = heatplot_y_order(complete_df, col, sortsim)

    return (plot(complete_df, x = :WindowFirst, y = :SeqName, color = col, Geom.rectbin,
         Guide.xlabel("Window Start (bp)"), Guide.ylabel("Sequence name"),
         Guide.colorkey(legend), Coord.cartesian(xmin = 0),
         Guide.title("$(legend) between $(ref) and other sequences (sliding window)"),
         Scale.y_discrete(order = o)), df)
end

#using Plots; gr(); sticks(linspace(0.25π,1.5π,5), rand(5), proj=:polar, yerr=.1)

function visualize(args)

    df = readtable(args["inputfile"],
                   separator = ',',
                   header = true)
    pool!(df, [:FirstSeq, :SecondSeq])

    if is_distance_data(df)
        # Data frame contains distances.
        leg = "Genetic distance"
        if is_windowed_data(df)
            # Data is computed across a sliding window.
            p, d = heatplot(df, :Value, args["reference"], leg)
        else
            p, d = heatplot(df, :Value, leg)
        end
    else
        # Data frame contains dates.
        leg = "Divergence time"
        if is_windowed_data(df)
            # Data is computed across a sliding window.
            p, d = heatplot(df, :MidEstimate, args["reference"], leg, args["sortsim"])
        else
            p, d = heatplot(df, :MidEstimate, leg)
        end
    end

    bkend = args["backend"]
    backend = process_backend(bkend)

    unit = process_units(args["units"])
    w = args["width"] * unit
    h = args["height"] * unit

    if args["table"]
        writetable("$(args["outputfile"])_plottable.csv", d)
    end

    draw(backend("$(args["outputfile"]).$bkend", w, h), p)
end
