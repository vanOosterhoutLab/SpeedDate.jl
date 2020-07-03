function read_fasta(filepath::String)
    @info "Reading FASTA file $filepath"
    open(FASTA.Reader, filepath) do f
        nread = 0
        record = FASTA.Record()
        seqs = Dict{String, LongSequence{DNAAlphabet{4}}}()
        while !eof(f)
            read!(f, record)
            nread += 1
            recname = FASTA.identifier(record)
            seqs[recname] = FASTA.sequence(LongSequence{DNAAlphabet{4}}}, record)
        end
        if nread > length(seqs)
            error("Only retained $(length(seqs)) of $nread records read. This is commonly caused by sequences with duplicate names. Check your FASTA file.")
        end
        @info "Done"
        return seqs
    end
end