
function gather_sequences(args)
    names = Vector{ASCIIString}()
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
        for i in open(args["file"], FASTA)
            push!(names, i.name)
            push!(seqs, i.seq)
        end
    end
    @assert length(seqs) >= 2 error("2 or more sequences must be provided.")
    return Indexer(names), seqs
end

function pairwise_dates{D<:EvolutionaryDistance,S<:Sequence}(sequences::Vector{S},
    mu::Float64, model::Type{D}, method)

    slen = length(sequences)
    times = zeros(Float64, slen, slen)
    for i = 1:slen, j = i+1:slen
        Dist, Var = distance(model, sequences[i], sequences[j])
        nmut = convert(Int, ceil(Dist * slen))
        T = coaltime(length(sequences[i]), nmut, mu, method)
        mT = Dating.middle(T)
        times[i, j] = times[j, i] = mT
    end
    return times
end

function pairwise_dates{D<:EvolutionaryDistance,S<:Sequence}(sequences::Vector{S},
    mu::Float64, model::Type{D}, method, width::Int64, length::Int64)



    slen = length(sequences)
    times = zeros(Float64, slen, slen)
    for i = 1:slen, j = i+1:slen
        Dist, Var = distance(model, sequences[i], sequences[j])
        nmut = convert(Int, ceil(Dist * slen))
        T = coaltime(length(sequences[i]), nmut, mu, method)
        mT = Dating.middle(T)
        times[i, j] = times[j, i] = mT
    end
    return times
end

function compute(args)
    index, sequences = gather_sequences(args)

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

    if args["scan"]
        if args["step"] <= 0
            args["step"] = args["width"]
        end
        times = pairwise_dates(sequences, args["mutation_rate"], model, dmethod, args["width"], args["step"])
    else
        times = pairwise_dates(sequences, args["mutation_rate"], model, dmethod)
        writedlm("$(args["outfile"]).txt", times)
    end
end
