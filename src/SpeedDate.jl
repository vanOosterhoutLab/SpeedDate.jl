module SpeedDate

export read_fasta, count_mutations, estimate_time

using BioSequences, FASTX, Distributions, Roots, PairwiseListMatrices

# For bit-parallel mutation counting
import Twiddle: enumerate_nibbles, nibble_mask, count_nonzero_nibbles, count_1111_nibbles

# Needed for using BioSequences' bit-wise operations code generator
import BioSequences: bitindex, encoded_data, index, offset, bitmask

include("read_sequences.jl")
include("count_mutations.jl")
include("estimation_algorithm.jl")
#include("plotting/visualize.jl")

end # Module
