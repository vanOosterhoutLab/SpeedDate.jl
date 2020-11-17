# Dating Sequences

You use SpeedDate in a very simple 2 step manner. First, count the mutations
between two sequences, and then you plug that information, plus a mutation rate
into the dating function.

You can use the basic functions, which work on a pair of sequences, plus other
BioJulia utilities to run any analysis of any combination of sequences you may
like. But there are also some extra methods of the basic functions provided for
convenience e.g. running sating between sequences in a sliding window, or doing
a pairwise analysis. The dating algorithm is the same in all cases, but you can
run it for two sequences, or pairwise between many sequences, or using a sliding
window.

Mutation counts come in the form of a simple `MutationCount` struct that contain
the number of mutations observed and the number of valid sites used to compare
(not all sites in a  sequence are counted as valid e.g. '-' and 'N' or other
ambiguous bases).

The coalescence time estimates come in the form of a simple `DatingEstimate`
struct that contain the confidence interval for the estimate. You can use
`lower`, `middle`, and `upper` functions for get the 5%, 50% and 95% values for
the interval respectively.

Let's see some example use cases:

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

If you have a dictionary of sequences such as you get after using `read_fasta`,
then `count_mutations` will work with that to produce a matrix of
mutation counts as well.


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


## Dating a set of homologous sequences over a sliding window

Use the `count_mutations` and `estimate_time` functions as for a set of sequences,
but additionally provide a parameter to `count_mutations` to specify a window size
in base pairs e.g.

```julia
seqs = read_fasta("cgd1_2210nuc.fas")
m_window_pairwise = count_mutations(seqs, 10)
age_window_pairwise = estimate_time(m_window_pairwise, 10e-8)
```

