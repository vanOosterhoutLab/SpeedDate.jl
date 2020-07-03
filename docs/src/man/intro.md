# Introduction

SpeedDate is a method of estimating a divergence time between two DNA sequences.
It was first implemented in the R package [HybridCheck](https://github.com/vanOosterhoutLab/HybridCheck)
in order to date regions of introgression between homologous contigs of assembled
genomes.

This SpeedDate package implements the very same algorithm in Julia, making it
faster than the original implementation. It is also built on top of packages
in the BioJulia framework, including [BioSequences.jl](https://github.com/BioJulia/BioSequences.jl).

## How does the estimation method work?

The divergence time is estimated using the number of mutations that have
occurred between two aligned sequences.

The calculation uses a strict molecular clock which assumes a constant
substitution rate, both through time and across taxa.

Modelling the mutation accumulation process as a Bernoulli trial, the
probability of observing $k$ or fewer mutations between two sequences of length
$n$ can be given as:

$Pr(X \le k) = \sum_{i=0}^{\lfloor k \rfloor} \binom{n}{i} p^i (1 - p)^{n-i}$

Where $p$ is the probability of observing that a single base position is a
mutation between the two aligned sequences.

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

## Loading SpeedDate

To begin using SpeedDate, fire up a Julia session enter the following into the
prompt:

```julia
using SpeedDate
```

!!! note
    This assumes you have installed SpeedDate already. See the quick-start
    section of the homepage to see how to install SpeedDate.

Once that's done, you're ok to continue and do one of the analyses described in
the rest of this manual.