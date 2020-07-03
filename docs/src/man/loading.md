# Loading Data

First things first you need to load your sequence data in order to use it in
SpeedDate.

SpeedDate currently supports the FASTA format for sequences, and assumed the
sequences have been aligned with some kind of multiple sequence alignment program,
such as [Clustal](http://www.clustal.org/clustal2/). As a result all of the
sequences typically should be of the same length as the alignment process adds
gap characters '-' to the sequences.

To read in a FASTA file use the `read_fasta` function:

```julia
my_seqs = read_fasta("my_sequences.fasta")
```