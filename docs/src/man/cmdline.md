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
