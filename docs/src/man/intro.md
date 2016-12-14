# Introduction

SpeedDate is the name given to a method of estimating a divergence time between
two DNA sequence regions that was first implemented in the R package
[HybridCheck](https://github.com/Ward9250/HybridCheck) in order to date regions
of introgression in large sequence contigs.

The current SpeedDate is implemented in the
[SpeedDate.jl](https://github.com/Ward9250/SpeedDate.jl) package, which depends
on [Bio.jl](https://github.com/BioJulia/Bio.jl) for core functionality like the
input and output of DNA sequences and data, and computation of mutation counts
and genetic distances.

## The dating estimation method

The divergence time is estimated using the number of mutations that have
occurred between two aligned sequences.

The calculation uses a strict molecular clock which assumes a constant
substitution rate, both through time and across taxa.

Modelling the mutation accumulation process as a Bernoulli trial, the
probability of observing $k$ or fewer mutations between two sequences of length
$n$ can be given as:

$Pr(X \le k) = \sum_{i=0}^{\lfloor k \rfloor} \binom{n}{i} p^i (1 - p)^{n-i}$

Where $p$ is the probability of observing a single mutation between the two
aligned sequences.

The value of $p$ depends on two key factors: the substitution rate and the
divergence time.

If you assume a molecular clock, whereby two DNA sequences are both accumulating
mutations at a rate $\mu$ for $t$ generations, then you may define $p = 2\mu t$.

Using these assumptions, the SpeedDate method finds the root of the following
formula for $Pr(X \le k) = 0.05$, $0.5$, and $0.95$, and then divides the three
answers by twice the assumed substitution rate.

$f(n, k, 2\mu t, Pr(X \le k) = \left( \sum_{i=0}^{\lfloor k \rfloor} \binom{n}{i} {2\mu t}^i (1 - 2\mu t)^{n-i}   \right) - Pr(X \le k)$

This results in an upper, middle, and lower estimate of the coalescence time
$t$ of the two sequences (expressed as the number of generations).

This method has been written into the Phylo module of the flagship package of
the BioJulia project, Bio.jl as a function called `coaltime`, and SpeedDate
simply bundles the steps of loading data, conting mutations in sequences, and
passing that information to `coaltime`, and writing results to file, easier.
