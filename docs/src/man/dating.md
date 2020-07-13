# Dating Sequences

SpeedDate can perform its dating estimate in a few different ways.
The algorithm is the same in all cases, but you can run it for two sequences,
or pairwise between many sequences, or using a sliding window.

## Dating a pair of homologous sequences

To estimate the divergence time of a single pair of homologous sequences,
first use the `count_mutations` function, to get the number of mutations that
are observed between the two sequences. Then use the `estimate_time` function
on the result, providing a value for the assumed substitution rate μ. E.g.

```julia
m_count = count_mutations(seqa, seqb)
t_estimate = estimate_time(m_count, 10e-7) # μ = 10e-7
```

`estimate_time` returns a `DatingEstimate` struct that represents a CI 
for the divergence time estimate by containing values for the 5%, 50% and 95%
estimates.


## Pairwise dating of a set of homologous sequences

If you have a set of homologous sequences - say genes - and you want to estimate
the divergence time between each pair of sequences, SpeedDate allows you to do
this, giving you a symmetrical matrix as a result, where each cell is the result
for a pair of sequences.

First you use `count_mutions` on a vector of sequences, which gives you a matrix
of mutation counts. Then you can use `estimate_time` to get a matrix of time
estimates. E.g.

```julia
count_matrix = count_mutations([seqa, seqb, seqc, seqd])
t_matrix = estimate_time(m_count, 10e-7) # μ = 10e-7
```

## Dating a pair of homologous sequences over a sliding window

To estimate the divergence time of a single pair of homologous sequences, using
a sliding window, first use the `count_mutations` function, providing the
two sequences, as well as a value to use as the size (in base-pairs) of the
sliding window. The result can then be used with the `estimate_time` function.
E.g.

```julia
window_counts = count_mutations(seqa, seqb, 50) # 50bp sliding window.
window_estimate = estimate_time(window_counts, 10e-7) # μ = 10e-7
```