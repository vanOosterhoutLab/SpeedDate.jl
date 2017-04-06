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

- "model": Either "jc69" or "k80".
- "mutation_rate": A number representing the mutation rate, e.g. 10e-9.
- "file": A string that is the filename e.g. "~/Desktop/myseqs.fasta".
- "outfile": A string that is the basename of all output files.
- "method": Either "default" or "simple", I recommend leaving as "default".
- "onlydist": Set to true of false depending on whether or not you only want the distances to be computed.
- "scan": false.

If you want to do the sliding window scan, the following should also be added
to the dictionary:

- "scan": true
- "size": A number representing the sliding window size.
- "step": A number representing the sliding window step.

# Plotting SpeedDate results from a julia script or session

You can plot the results of the SpeedDate program from within a julia console
session or script.

To do this, create a dictionary of arguments and then give that to the
`SpeedDate.visualize` function.

```julia
using SpeedDate

options = Dict("width" => 12.0,
               "height" => 8.0,
               "units" => "cm",
               "backend" => "svg",
               "reference" => "default",
               "table" => false,
               "sortsim" => false,
               "inputfile" => "myresults.csv",
               "outputfile" => "myplot.svg")

SpeedDate.visualize(options)

```

The arguments dictionary should have the following fields:

- "width": Width of the plot.
- "height": Height of the plot.
- "units": Units for width and height of the plot ("cm", "mm" or "inch").
- "backend": The backend used to produce the plot.
- "reference": The name of the DNA sequence to use as a reference when plotting a windowed analysis.
- "table": Set to true to write out the table that was generated for plotting - only really useful for debugging.
- "sortsim": Set to true to sort the rows of the output table by average sequence similarity if you are plotting a windowed analysis. 
- "inputfile": The pathname of the SpeedDate results file you want to plot.
- "outputfile": A name for the output plot.
