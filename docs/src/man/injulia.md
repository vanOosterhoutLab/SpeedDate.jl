# Using SpeedDate from a julia script or session

You can execute the SpeedDate program from within a julia console session or
script.

To do this, create a dictionary of arguments and then give that to the
`SpeedDate.compute` function.

```julia
using SpeedDate

options = Dict("model" => "jc69",
               "mutation_rate" => 10e-9,
               "method" => "default",
               "scan" => false,
               "onlydist" => false,
               "file" => "contig1_ac.fas",
               "outfile" => "test")

SpeedDate.compute(options)
```

The dictionary should have the following fields:

- "model" => Either "jc69" or "k80".
- "mutation_rate" => A number representing the mutation rate, e.g. 10e-9.
- "file" => A string that is the filename e.g. "~/Desktop/myseqs.fasta".
- "outfile" => A string that is the basename of all output files.
- "method" => Either "default" or "simple", I recommend leaving as "default".
- "onlydist" => Set to true of false depending on whether or not you only want the distances to be computed.
- "scan" => false.

If you want to do the sliding window scan, the following should also be added
to the dictionary:

- "scan" => true
- "size" => A number representing the sliding window size.
- "step" => A number representing the sliding window step.
