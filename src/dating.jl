
function gather_sequences(args)
    names = Vector{String}()
    seqs =  Vector{DNASequence}()
    if haskey(args, "dnaseqs")
        n = 0
        for i in args["dnaseqs"]
            n += 1
            push!(names, "cmdSeq_$n")
            push!(seqs, i)
        end
    end
    if haskey(args, "file") && typeof(args["file"]) != Void
        for i in open(FASTAReader, args["file"])
            push!(names, i.name)
            push!(seqs, i.seq)
        end
    end
    @assert length(seqs) >= 2 error("2 or more sequences must be provided.")
    return Indexer(names), seqs
end

function generate_names_lists(indexer::Indexer)
    l = length(names(indexer))
    list1 = Vector{Symbol}(binomial(l, 2))
    list2 = Vector{Symbol}(binomial(l, 2))
    k = 0
    for i in 1:l
        for j in i+1:l
            k += 1
            list1[k] = indexer.names[i]
            list2[k] = indexer.names[j]
        end
    end
    return list1, list2
end

function maketable(names1::Vector{Symbol}, names2::Vector{Symbol}, windows::Vector{UnitRange{Int64}}, values::Matrix{Float64}, sepcol::Bool)
    nwindows = length(windows)
    firstseq = repeat(names1, inner = nwindows)
    secondseq = repeat(names2, inner = nwindows)
    value = reshape(values, *(size(values)...))
    if sepcol
        firsts = collect(first(x) for x in windows)
        lasts = collect(last(x) for x in windows)

        table = DataFrame(FirstSeq = firstseq,
                          SecondSeq = secondseq,
                          WindowFirst = repeat(firsts, outer = length(names1)),
                          WindowLast = repeat(lasts, outer = length(names1)),
                          Value = value)
    else
        table = DataFrame(FirstSeq = firstseq,
                          SecondSeq = secondseq,
                          Window = repeat(windows, outer = length(names1)),
                          Value = value)
    end
    return table
end

function maketable(names1::Vector{Symbol}, names2::Vector{Symbol}, windows::Vector{UnitRange{Int64}}, values::Matrix{SDResult}, sepcol::Bool)
    nwindows = length(windows)
    firstseq = repeat(names1, inner = nwindows)
    secondseq = repeat(names2, inner = nwindows)
    value = reshape(values, *(size(values)...))
    maxest = collect(Dating.upper(x) for x in value)
    midest = collect(Dating.middle(x) for x in value)
    minest = collect(Dating.lower(x) for x in value)
    if sepcol
        firsts = collect(first(x) for x in windows)
        lasts = collect(last(x) for x in windows)

        table = DataFrame(FirstSeq = firstseq,
                          SecondSeq = secondseq,
                          WindowFirst = repeat(firsts, outer = length(names1)),
                          WindowLast = repeat(lasts, outer = length(names1)),
                          UpperEstimate = maxest,
                          MidEstimate = midest,
                          LowerEstimate = minest)
    else
        table = DataFrame(FirstSeq = firstseq,
                          SecondSeq = secondseq,
                          Window = repeat(windows, outer = length(names1)),
                          UpperEstimate = maxest,
                          MidEstimate = midest,
                          LowerEstimate = minest)
    end
    return table
end

function maketable(names1::Vector{Symbol}, names2::Vector{Symbol}, values::Vector{Float64})
    return DataFrame(FirstSeq = names1, SecondSeq = names2, Value = values)
end

function maketable(names1::Vector{Symbol}, names2::Vector{Symbol}, values::Vector{SDResult})
    minest = collect(Dating.lower(x) for x in values)
    midest = collect(Dating.middle(x) for x in values)
    maxest = collect(Dating.upper(x) for x in values)
    return DataFrame(FirstSeq = names1, SecondSeq = names2,
                     LowerEst = minest, MiddleEst = midest, UpperEst = maxest)
end

function compute(args)

    println("Loading sequences.")
    index, sequences = gather_sequences(args)
    names1, names2 = generate_names_lists(index)
    slen = length(sequences[1])
    for seq in sequences
        @assert length(seq) == slen error("Sequences must be of the same length!")
    end

    m = lowercase(args["model"])
    if m == "jc69"
        model = JukesCantor69
    elseif m == "k80"
        model = Kimura80
    else
        error("Invalid choice of distance model.")
    end
    met = lowercase(args["method"])
    if met == "default"
        dmethod = SpeedDating
    elseif met == "simple"
        dmethod = SimpleEstimate
    else
        error("Invalid choice of coalescence time estimate method.")
    end

    println("Computing evolutionary distances.")
    if args["scan"]
        slen = args["width"]
        dists, vars, windows = distance(model, sequences, slen, slen)
        table = maketable(names1, names2, windows, dists, args["sepcol"])
    else
        dists, vars = distance(model, sequences)
        table = maketable(names1, names2, dists)
    end
    writetable("$(args["outfile"])_distances.csv", table)

    println("Estimating divergence times.")
    if !args["onlydist"]
        times = coaltime(slen, dists, args["mutation_rate"], dmethod)
        if args["scan"]
            table = maketable(names1, names2, windows, times, args["sepcol"])
        else
            table = maketable(names1, names2, times)
        end
        writetable("$(args["outfile"])_ctimes.csv", table)
    end
end
