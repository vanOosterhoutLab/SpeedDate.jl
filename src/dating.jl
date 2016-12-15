
DE = DatingEstimate

function dists_to_dates{A<:AbstractArray,R<:DE}(dists::A{Float64}, len::Int, mu::Float64, ::Type{R})
    Ts = similar(dists, R)
    @inbounds for i in eachindex(dists)
        nmut = convert(Int, ceil(dists[i] * len))
        Ts[i] = coaltime(len, nmut, mu, SpeedDating)
    end
    return Ts
end

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

function write_results(filename::String, names1::Vector{Symbol},
    names2::Vector{Symbol}, values::Vector{Float64})

    outfile = open(filename, "w")
    for i in 1:length(names1)
        print(outfile, names1[i])
        print(outfile, ", ")
        print(outfile, names2[i])
        print(outfile, ", ")
        print(outfile, values[i])
        print(outfile, "\n")
    end
    close(outfile)
end

function write_results(filename::String, names1::Vector{Symbol},
    names2::Vector{Symbol}, values::Matrix{Float64})

    outfile = open(filename, "w")
    for i in 1:length(names1)
        print(outfile, names1[i])
        print(outfile, ", ")
        print(outfile, names2[i])
        for value in values[:,i]
            print(outfile, ", ")
            print(outfile, value)
        end
        print(outfile, "\n")
    end
    close(outfile)
end

function write_results(filename::String, names1::Vector{Symbol},
    names2::Vector{Symbol}, values::Vector{SDResult})

    outfile = open(filename, "w")
    for i in 1:length(names1)
        print(outfile, names1[i])
        print(outfile, ", ")
        print(outfile, names2[i])
        print(outfile, ", ")
        print(outfile, lower(values[i]))
        print(outfile, ", ")
        print(outfile, Dating.middle(values[i]))
        print(outfile, ", ")
        print(outfile, upper(values[i]))
        print(outfile, "\n")
    end
    close(outfile)
end

function write_results(filename::String, names1::Vector{Symbol},
    names2::Vector{Symbol}, values::Matrix{SDResult})

    minfile = open("min_$filename", "w")
    midfile = open("mid_$filename", "w")
    maxfile = open("max_$filename", "w")
    for i in 1:length(names1)
        print(minfile, names1[i])
        print(minfile, ", ")
        print(minfile, names2[i])
        print(midfile, names1[i])
        print(midfile, ", ")
        print(midfile, names2[i])
        print(maxfile, names1[i])
        print(maxfile, ", ")
        print(maxfile, names2[i])
        for value in values[:,i]
            print(minfile, ", ")
            print(minfile, lower(value))
            print(midfile, ", ")
            print(midfile, Dating.middle(value))
            print(maxfile, ", ")
            print(maxfile, upper(value))
        end
        print(minfile, "\n")
        print(midfile, "\n")
        print(maxfile, "\n")
    end
    close(minfile)
    close(midfile)
    close(maxfile)
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

    if args["scan"]
        if args["step"] <= 0
            args["step"] = args["width"]
        end
        dists, vars, windows = distance(model, sequences, args["width"], args["step"])
        slen = args["width"]
    else
        dists, vars = distance(model, sequences)
    end
    write_results("$(args["outfile"])_distances.txt", names1, names2, dists)

    if !args["onlydist"]
        times = dists_to_dates(dists, slen, args["mutation_rate"], dmethod)
        write_results("$(args["outfile"])_ctimes.txt", names1, names2, times)
    end
end
