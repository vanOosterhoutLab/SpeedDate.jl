
"""
DatingEstimate is a simple datatype to store the results of the coaltime function.
coaltime estimates date range that may be considered a 95% confidence range in
which the true coalsescence time between two sequences lies.
The type stores the 5%, 50%, and 95% values for the range.
"""
struct DatingEstimate
    lower::Float64
    middle::Float64
    upper::Float64
end

lower(x::DatingEstimate) = x.lower
middle(x::DatingEstimate) = x.middle
upper(x::DatingEstimate) = x.upper

function Base.show(io::IO, de::DatingEstimate)
    println(io, "Coalescence time estimate:\n5%: $(de.lower), 95%: $(de.upper)")
end

@inline function binomzero(p0::Float64, N::Int, B::Int)
    f(p::Float64) = cdf(Binomial(N, p), B) - p0
    return fzero(f, 0, 1)
end

"""
    estimate_time(N::Int, K::Int, µ::Float64)
    
Compute the coalescence time between two sequences by modelling the process of
mutation accumulation between two sequences as a bernoulli process.

`N` is the length of the two aligned sequences.
`K` is the estimated number of mutations.
`µ` is the assumed mutation rate.
"""
@inline function estimate_time(N::Int, K::Int, µ::Float64)
    if !(N ≥ K ≥ 0)
        throw(ArgumentError("Condition must be satisfied: N ≥ K ≥ 0"))
    end
    div = 2µ
    ninetyfive = ceil(binomzero(0.05, N, K) / div)
    fifty = ceil(binomzero(0.5, N, K) / div)
    five = ceil(binomzero(0.95, N, K) / div)
    return DatingEstimate(five, fifty, ninetyfive)
end

"""
    estimate_time(N::Int, K::Int, µ::Float64)
    
Compute the coalescence time between two sequences by modelling the process of
mutation accumulation between two sequences as a bernoulli process.

`N` is the length of the two aligned sequences.
`d` is the a value of estimated genetic distance.
`µ` is the assumed mutation rate.
"""
@inline function estimate_time(N::Int, d::Float64, µ::Float64)
    if !(1.0 ≥ d ≥ 0.0)
        throw(ArgumentError("Genetic distance `d` must be a value between 1 and 0"))
    end
    K = convert(Int, ceil(d * N))
    return estimate_time(N, K, µ)
end

function estimate_time(m::MutationCount, μ::Float64)
    return estimate_time(m.n_sites, m.n_mutations, μ)
end

estimate_time(V::Vector{MutationCount}, μ::Float64) = [estimate_time(v, μ) for v in V]

function estimate_time(M::PairwiseListMatrix{MutationCount,false}, μ::Float64)
    V = [estimate_time(m, μ) for m in getlist(M)]
    return PairwiseListMatrix(V, false)
end