using Test, SpeedDate, BioSequences

@testset "Mutation Counting" begin
    @testset "Catching every mutation type" begin
        function generate_possibilities_tester(::Type{A}) where {A <: NucleicAcidAlphabet}
            sym = symbols(A())
            arra = Vector{eltype(A)}()
            arrb = Vector{eltype(A)}()
            for i in 1:length(sym), j in i:length(sym)
                push!(arra, sym[i])
                push!(arrb, sym[j])
            end
            return LongSequence{A}(arra), LongSequence{A}(arrb)
        end
    
        @testset "2 - Bit" begin
            dnaA, dnaB = generate_possibilities_tester(DNAAlphabet{2})
            @test count_mutations(dnaA, dnaB) == count_mutations(dnaB, dnaA) == 6
        end
    
        @testset "4 - Bit" begin
            dnaA, dnaB = generate_possibilities_tester(DNAAlphabet{4})
            @test count_mutations(dnaA, dnaB) == count_mutations(dnaB, dnaA) == (6, 10)
        end
    end
    
    @testset "Randomized tests" begin
        
    end
end
