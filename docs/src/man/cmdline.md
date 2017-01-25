# Running SpeedDate as a command line application

SpeedDate can be started from the command line by invoking the following line
in a terminal.

```
julia -e"using SpeedDate; SpeedDate.main()"
```

# Computing divergence times

The `compute` command is invoked to compute genetic distances and divergence
times for an input aligned FASTA file.

Use the -h flag to display the possible options for the `compute` command:

```
julia -e"using SpeedDate; SpeedDate.main()" compute -h
usage: <PROGRAM> compute [-f FILE] [-s [DNASEQS...]] [-m MODEL]
                        [-r MUTATION_RATE] [--method METHOD]
                        [-o OUTFILE] [--scan] [-w WIDTH] [-c]
                        [--onlydist] [-h]

optional arguments:
  -f, --file FILE       An input file.
  -s, --dnaseqs [DNASEQS...]
                        The first of two DNA sequences to test (type:
                        Bio.Seq.BioSequence{Bio.Seq.DNAAlphabet{4}})
  -m, --model MODEL     The model used to compute genetic distances.
                        Currently jc69, and k80 are supported.
                        (default: "jc69")
  -r, --mutation_rate MUTATION_RATE
                        The mutation rate to be assumed. (type:
                        Float64, default: 1.0e-8)
  --method METHOD       The dating method to use. Currently 'default'
                        and 'simple' are supported.  (default:
                        "default")
  -o, --outfile OUTFILE
                        Base name for the output files(s). (default:
                        "SpeedDate")
  --scan                Whether or not to compute dates across
                        sequences with a window.
  -w, --width WIDTH     Width of the window across sequences. (type:
                        Int64, default: 100)
  -c, --sepcol          Write the start and end points of sliding
                        windows in separate columns of output table.
  --onlydist
  -h, --help            show this help message and exit
```

### Entering DNA sequences

You will see that you can enter DNA sequences either from a FASTA formatted
file using the `-f` or `--file` flags. Alternatively short sequences can be
typed out on the command line using the `-s` or `--dnaseqs` flags.

### Parameters for divergence time estimation.

SpeedDate computes evolutionary distances between sequences (or windows of
sequences if you are estimating divergence times using a sliding window - see below.),
by default this is currently the Jukes & Cantor 69 distance, but can be set to
Kimura's 80 distance, by providing the option `-m k80` or `--model k80`.
More estimates are anticipated in future versions.

SpeedDate requires a mutation rate to estimate divergence times, by default
this is 1.0e-8, but may be altered by using the `-r` or `--mutation_rate` flag.

By default the SpeedDate method will be used which gives a 95% CI range for the
divergence time, but a simpler estimate can be used
which gives a single point estimate of the expected divergence time. To do this
pass the flag option `--method simple`.

Use the `--scan` option flag to indicate you want to compute the divergence times
for windows across your sequences. Set the size of the windows with the flag `-w`,
e.g. `-w 1000`.

When you run SpeedDate a .csv file containing the evolutionary distance measures,
and a .csv file containing the divergence time estimates between your sequences
will be output. You can set the base name these output files with `--outfile` or
`-o`.


### Extra options

If the flag `--onlydist` is used, then SpeedDate will only compute the
evolutionary distance measures and output them to file. It will not go on to
produce divergence time estimates.   


# Plotting SpeedDate results

The `compute` command will write out the results to file as a data-frame, in a
text-based file format (csv). This format should be familiar to users of R and
other software frameworks that use a similar tabular data structure.

The `plot` command is invoked to plot the results of a `compute` run.
Of course the user can use whatever plotting solution they desire if they are
happy scripting with the resulting data-frame files.

The plot command is very simple and will create simple heat plots using the
[Gadfly.jl](http://gadflyjl.org/stable/) framework.

The options available to the user for plotting can be viewed using the `-h` flag:

```
julia -e"using SpeedDate; SpeedDate.main()" plot -h

usage: <PROGRAM> plot [--width WIDTH] [--height HEIGHT]
                      [--units UNITS] [--backend BACKEND]
                      [--reference REFERENCE] [-h] [inputfile]
                      [outputfile]

positional arguments:
  inputfile             The file name of the input data.
  outputfile            The file name of the output plot.

optional arguments:
  --width WIDTH         Width of the plot. (type: Float64, default:
                        12.0)
  --height HEIGHT       Height of the plot. (type: Float64, default:
                        8.0)
  --units UNITS         Units for width and height of the plot.  Must
                        be one of 'inch', 'mm', or 'cm'.  (default:
                        "cm")
  --backend BACKEND     The backend used to produce the plot.  Must be
                        one of 'svg', 'svgjs', 'png', 'pdf', 'ps', or
                        'pgf'.  (default: "svg")
  --reference REFERENCE
                        The name of the DNA sequence to use as a
                        reference when plotting a windowed analysis.
                        (default: "default")
  -h, --help            show this help message and exit
```

The command is very simple, with two obligatory arguments: first the filename
of a SpeedDate results file is provided, followed by a name for the output plot.

Optionally: You can set the width and the height of the generated plot with the
flags `--width` and `--height`, and you can specify the units of the width and
height (in mm, cm, or inches), with the `--units` flag. By default the units
are in centimeters (cm).

You can choose which backend is used to save the plot (i.e. the file format)
using the `--backend` flag. Most commonly you will want a vectorized format
("svg" or "pdf"), or a rasterized format ("png"). By default the plot will be
drawn using an SVG backend.

Finally, if you are plotting results from a SpeedDate run which used a sliding
window, then you can set the name of the sequence to use as the reference
sequence, against which all other sequences are plotted. By default, this falls
back to the first sequence name that is mentioned in the results file you give
the plot command.

This command can plot distances or divergence times produced by SpeedDate.
The divergence times plotted are the "middle estimates". Recall from the intro
of this manual that SpeedDate makes upper, middle, and lower estimates of the
divergence time, forming a 95% confidence interval in which the true age
is estimated to lie.

An example usage is below. The input file is called "SpeedDate_distances.csv",
the output plot is given the name "myplot", the plot is written out in PNG
format, and the width and height of the plot are set to 50 and 45 cm.

```
julia -e"using SpeedDate; SpeedDate.main()" plot SpeedDate_distances.csv testplot --backend png --width 50.0 --height 45.0
```
