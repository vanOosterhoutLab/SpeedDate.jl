struct PairwiseAnalysis
    names::Set{String}
end

function pairwise_analysis(seqs::Dict{String, LongSequence{DNAAlphabet{4}}})
    names = collect(keys(seqs))
    
end


# Mutated

@inline function mask_unambiguous(x::UInt64)
    return nibble_mask(enumerate_nibbles(x), 0x1111111111111111)
end

@inline function mask_unambiguous(a::UInt64, b::UInt64)
    return mask_unambiguous(a) & mask_unambiguous(b)
end

@inline function mutation_bitcount(x::UInt64, y::UInt64, ::DNAAlphabet{4})
    m = mask_unambiguous(x, y)
    d = (x ⊻ y) & m
    return count_nonzero_nibbles(d), count_1111_nibbles(m)
end

@inline mutation_bitcount(x::UInt64, y::UInt64, ::DNAAlphabet{2}) = BioSequences.mismatch_bitcount(x, y, DNAAlphabet{2}())

# Counting mutations
let
    @info "Compiling bit-parallel mutation counter for LongSequence{<:NucleicAcidAlphabet}"
    
    counter4 = quote
        c, n = mutation_bitcount(x, y, A())
        count += c
        N += n
    end
    
    counter2 = :(count += mutation_bitcount(x, y, A()))
    
    BioSequences.compile_2seq_bitpar(
        :count_mutations_bitpar,
        arguments = (:(seqa::LongSequence{A}), :(seqb::LongSequence{A})),
        parameters = (:(A<:NucleicAcidAlphabet{4}),),
        init_code = :(count = 0; N = 0),
        head_code = counter4,
        body_code = counter4,
        tail_code = counter4,
        return_code = :(return count, N)
    ) |> eval
    
    BioSequences.compile_2seq_bitpar(
        :count_mutations_bitpar,
        arguments = (:(seqa::LongSequence{A}), :(seqb::LongSequence{A})),
        parameters = (:(A<:NucleicAcidAlphabet{2}),),
        init_code = :(count = 0),
        head_code = counter2,
        body_code = counter2,
        tail_code = counter2,
        return_code = :(return count)
    ) |> eval
end

count_mutations(seqa::LongSequence{<:NucleicAcidAlphabet}, seqb::LongSequence{<:NucleicAcidAlphabet}) = count_mutations(promote(seqa, seqb)...)
count_mutations(seqa::LongSequence{A}, seqb::LongSequence{A}) where {A<:NucleicAcidAlphabet} = count_mutations_bitpar(seqa, seqb)

 




