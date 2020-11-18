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

The polymorphisms in DNA or RNA nucleotide sequences from two or more individuals can be used to estimate the divergence time between the sequences.
This is commonly known as coalescence dating, and it is widely applied in evolutionary biology and population genetics, for example to analyse a population’s demography, or to assess the effects of selection, recombination or gene flow.
Different methods have been developed to estimate the divergence time (or coalescence time). Methods that are based on a strict molecular clock extrapolate a divergence time by simply counting the number of nucleotide differences between two sequences, and they assume that mutations occur at a constant rate through time.
Other methods infer the divergence time by simulating and modelling more complex evolutionary histories, i.e. relaxed clock and Bayesian coalescence-based approaches.
SpeedDate applies a strict molecular clock to rapidly estimate the divergence time between pairwise sequences across genes, entire chromosomes or genomes, and it uses a sliding window approach to quantify the variation in divergence time across the entire nucleotide sequence.


# Statement of need 

SpeedDate is a method of estimating the divergence time between two DNA or RNA sequences.
It was first implemented in the R package HybridCheck [@Ward2016], and it was used to date regions of genetic introgression between homologous contigs of assembled genomes.
It was developed to study whole genome sequence data of multiple individuals from plant pathogen populations [@McMullan2015], and as such, it was designed to rapidly return reasonable estimates of divergence time of large numbers of recombinant regions.
Other more sophisticated applications can give more precise estimates of the divergence time, but these require more information, and they are far more computationally intensive [@Bouckaert2014]. 

The SpeedDate.jl package implements the same algorithm developed and tested during the development of HybridCheck [@Ward2016], and has implemented this in the Julia programming language, making it faster than the original implementation in the HybridCheck R package.
It is also built on top of packages in the BioJulia framework, including the BioSequences.jl package.
The divergence time is estimated by summing the number of single nucleotide polymorphisms (SNPs) between two aligned sequences.
The calculation uses a strict molecular clock which assumes a constant substitution rate over time and across the genome, and models the mutation accumulation process as a Bernoulli trial. More details about the model are in the SpeedDate.jl online manual and in the HybridCheck paper [@Ward2016].

The SpeedDate algorithm has been used to date stretches of genome sequence affected by historical introgression in human pathogens [@Nader2019], plant pathogens [@McMullan2015], and plant resistance genes (R genes) (Jouet et al. 2015).
The algorithm incorporated in SpeedDate.jl is a useful standalone tool, as its utility extends beyond how it is used in HybridCheck to date genome sequences affected by recombination.
For example, the divergence times of the SpB-like regions of the yeast genome [@Eberlein2019] were analysed using the algorithm, and this analysis was conducted irrespective of whether the nucleotide sequences were affected by recombination or not.
SpeedDate is user-friendly method that is quick to run, and it is a useful tool for exploratory analyses of variation in coalescence time across genomes.
This makes SpeedDate complimentary to other more intensive methods used in the field.

# Acknowledgements

# References