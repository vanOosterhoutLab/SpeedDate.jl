# Dating Sequences

SpeedDate can perform its dating estimate in a few different ways.
The algorithm is the same in all cases, but you can run it for two sequences,
or pairwise between many sequences, or using a sliding window.

## Dating a pair of homologous sequences

To estimate the divergence time of a single pair of homologous sequences,
first use the `count_mutations` function, to get the number of mutations that
are observed between the two sequences. Then use the `estimate_time` function
on the result. E.g.

```julia
m_count = count_mutations(seqa, seqb)
t_estimate = estimate_time(m_count)
```

`estimate_time` returns a `DatingEstimate` struct that represents a CI 
for the divergence time estimate by containing values for the 5%, 50% and 95%
estimates.


## Pairwise dating of a set of homologous sequences

## Dating a pair of homologous sequences over a sliding window

 