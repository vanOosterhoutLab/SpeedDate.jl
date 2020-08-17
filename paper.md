---
title: 'SpeedDate.jl: Rapid DNA sequence divergence-time estimation'
tags:
  - Julia
  - biology
  - bioinformatics
  - sequences
  - evolution
  - date
  - divergence time
authors:
  - name: Ben J. Ward
    orcid: 0000-0001-6337-5238
    affiliation: 1
  - name: Cock van Oosterhout
    affiliation: 2
affiliations:
 - name: Earlham Institute, Norwich Research Park, Norwich, NR4 7UZ, UK
   index: 1
 - name: School of Environmental Sciences, Norwich Research Park, University of East Anglia, Norwich, NR4 7TJ, UK
   index: 2
date: 15 August 2020
bibliography: paper.bib
---

# Summary

In evolutionary biology and population genetics, it is common to look at gene or
genome sequences from two or more individuals, and want to know the divergence
time between the sequences. That is, for how long have the two sequences been
diverging from their common ancestor? There are many different ways to trying
to estimate the divergence time. Simple methods extrapolate a divergence time
from how many differences the sequences have, by assuming that mutations occur
at a constant rate through time. Other methods for inferring the divergence time
involve simulation and modelling more complex evolutionary histories.

# Statement of need 

`SpeedDate` is a method of estimating a divergence time between two DNA sequences.
It was first implemented in the R package `HybridCheck` [@Ward2016].
It was specifically used to date regions of introgression between homologous
contigs of assembled genomes. Because it was designed for a study involving whole
genome sequencing data of multiple individuals from plant pathogen populations
[@McMullan2015].
As such it was designed to give rapid reasonable estimates, rather than precise
estimates that methods that are far more computationally intensive [@Bouckaert2014].
The SpeedDate method then is simple and quick to run for example on
a sliding window over entire genomes, making it more useful for exploratory and
broad stroke assesments of evolutionary dynamics across a genome. It is then 
complimentary with other more intensive methods used in the field.

The `SpeedDate.jl` package implements the very same algorithm for general use,
in the Julia programming language, making it faster than the original implementation
in the `HybridCheck` R package. It is also built on top of packages in the
`BioJulia` framework, including the `BioSequences.jl` package.
The divergence time is estimated using the number of mutations that have occurred
between two aligned sequences. The calculation uses a strict molecular clock
which assumes a constant substitution rate, both through time and across taxa, and
models the mutation accumulation process as a Bernoulli trial. More details about
the model are in the `SpeedDate.jl` online manual.

The `SpeedDate` algorithm has been used to date stretches of genome sequence
affected by historical introgression in human pathogens [@Nader2019], and plant
pathogens [@McMullan2015]. The authors (of `SpeedDate.jl` and `HybridCheck`)
saw that the algorithm should be provided in `SpeedDate.jl` as its own standalone
tool, as its utility extends beyond how it is used in `HybridCheck` to date genome
sequences affected by recombination. For example, HybridCheck was used to compute
SpeedDate estimates for the SpB-like regions of the yeast genome [@Eberlein2019].
To do this the users would have had to "trick" `HybridCheck` to see these regions
as zones affected by recombination. `SpeedDate.jl` provides the algorithm in a
simple to use and standalone function, for this and any other use cases.

# Acknowledgements

# References