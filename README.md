# SpeedDate.jl

A simple tool for the estimation of coalescence times between sequences.
Created with julia and [Bio.jl](https://github.com/BioJulia/Bio.jl)

## Quick Start & Installation

### A really quick start - Binder notebook

If you don't have or want to install julia or the package but still want to use
the funtionality of SpeedDate, then a Binder IPython/IJulia notebook cloud
session can be launched by clicking this: [![Binder](http://mybinder.org/badge.svg)](http://mybinder.org:/repo/ward9250/sd_binder)

### Installation

First you should have [julia installed](https://github.com/JuliaLang/julia).

Open a julia terminal and enter:

Enter in a Julia terminal:
```julia
Pkg.clone("https://github.com/Ward9250/SpeedDate.jl.git")
```
To download and install the master branch.

### Useage

#### On the command line:

SpeedDate can be started from the command line by invoking the following line in
a terminal:

```sh
julia -e"using SpeedDate; SpeedDate.main()"
```

The `compute` command is invoked to compute genetic distances and coalescence times
for an input aligned FASTA file. Use the -h flag to display the possible options
for the `compute` command:

```
julia -e"using SpeedDate; SpeedDate.main()" compute -h

usage: <PROGRAM> compute [-f FILE] [-s [DNASEQS...]] [-m MODEL]
                        [-r MUTATION_RATE] [--method METHOD]
                        [-o OUTFILE] [--scan] [-w WIDTH] [-j STEP]
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
                        sequences with a sliding window.
  -w, --width WIDTH     Width of the sliding window across sequences.
                        (type: Int64, default: 100)
  -j, --step STEP       The number of base pairs the sliding window
                        moves by each iteration. (type: Int64,
                        default: -1)
  --onlydist
  -h, --help            show this help message and exit
```

##### Using a GTK based GUI

If you use the `interactive` command instead of the `compute` command, you will
be presented with a GTK based graphical user interface.

```
julia -e"using SpeedDate; SpeedDate.main()" interactive
```

#### From inside a julia session.
You can execute the SpeedDate program from within a julia console session or
script. To do this, create a dictionary of arguments and then give that to the
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

If you want to do the sliding window scan, the following should also be added to
the dictionary:

- "scan" => true
- "size" => A number representing the sliding window size.
- "step" => A number representing the sliding window step.

_A note about unit tests, as SpeedDate essentially wraps Bio.jl functionality in a command line or GTK gui, no unit tests have been included yet, as the functions used have their own unit tests in the BioJulia project in which they are defined._
