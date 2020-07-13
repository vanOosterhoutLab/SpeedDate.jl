module SpeedDate

export count_mutations

using BioSequences, FASTX, Distributions, Roots, PairwiseListMatrices

# For bit-parallel mutation counting
import Twiddle: enumerate_nibbles, nibble_mask, count_nonzero_nibbles, count_1111_nibbles

# Needed for using BioSequences' bit-wise operations code generator
import BioSequences: bitindex, encoded_data, index, offset, bitmask

include("count_mutations.jl")
include("estimation_algorithm.jl")
include("pairwise_distance.jl")
#include("dating/dating.jl")
#include("plotting/visualize.jl")

#=
function parse_command_line()
    s = ArgParseSettings()
    s.add_help = true

    @add_arg_table s begin
        "compute"
            help = "Compute coalescence times."
            action = :command
        "interactive"
            help = "Start the interactive GUI for SpeedDate."
            action = :command
        "plot"
            help = "Produce quick plots from SpeedDate results files."
            action = :command
    end

    @add_arg_table s["compute"] begin
        "--file", "-f"
            help = "An input file."
            arg_type = String
            required = false
        "--dnaseqs", "-s"
            help = "An array of DNA sequences."
            required = false
            arg_type = BioSequence{DNAAlphabet{4}}
            nargs = '*'
        "--model", "-m"
            help = """
            The model used to compute genetic distances.
            Currently jc69, and k80 are supported.
            """
            arg_type = String
            default = "jc69"
        "--mutation_rate", "-r"
            help = "The mutation rate to be assumed."
            arg_type = Float64
            default = 10e-9
        "--method"
            help = """
            The dating method to use.
            Currently 'default' and 'simple' are supported.
            """
            arg_type = String
            default = "default"
        "--outfile", "-o"
            help = "Base name for the output files(s)."
            default = "SpeedDate"
            arg_type = String
        "--scan"
            help = "Whether or not to compute dates across sequences with a window."
            action = :store_true
        "--width", "-w"
            help = "Width of the window across sequences."
            arg_type = Int64
            default = 100
        "--onlydist"
            action = :store_true
    end

    @add_arg_table s["plot"] begin
        "--width"
            help = "Width of the plot."
            arg_type = Float64
            default = 12.0
        "--height"
            help = "Height of the plot."
            arg_type = Float64
            default = 8.0
        "--units"
            help = """
            Units for width and height of the plot.

            Must be one of 'inch', 'mm', or 'cm'.
            """
            arg_type = String
            default = "cm"
            range_tester = allowed_units
        "--backend"
            help = """
            The backend used to produce the plot.

            Must be one of 'svg', 'svgjs', 'png', 'pdf', 'ps', or 'pgf'.
            """
            arg_type = String
            default = "svg"
            range_tester = allowed_backend
        "--reference"
            help = """
            The name of the DNA sequence to use as a reference when plotting
            a windowed analysis.
            """
            arg_type = String
            default = "default"
        "--table"
            help = "Save the table used for plotting to file."
            action = :store_true
        "--sortsim"
            help = "Sort the rows of the output table by average sequence similarity if you are plotting a windowed analysis."
            action = :store_true
        "inputfile"
            help = "The file name of the input data."
            arg_type = String
        "outputfile"
            help = "The file name of the output plot."
            arg_type = String
    end

    return parse_args(s)
end

function main()
    #try
        arguments = parse_command_line()
        if arguments["%COMMAND%"] == "compute"
            compute(arguments["compute"])
        end
        if arguments["%COMMAND%"] == "interactive"
            include("gtk_gui.jl")
            start_interactive_app()
        end
        if arguments["%COMMAND%"] == "plot"
            visualize(arguments["plot"])
        end
    #catch err
        #(STDOUT, "SpeedDate could not complete analysis.\nReason:\n$(err.msg)\n")
    #end
end
=#

end # Module
