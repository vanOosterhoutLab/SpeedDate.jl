module SpeedDate

using ArgParse
using Bio: Seq, Var, Phylo.Dating, Indexers

include("compute.jl")
include("visualize.jl")

function parse_command_line()
    s = ArgParseSettings()
    s.add_help = true

    @add_arg_table s begin
        "compute"
            help = "Compute coalescence times."
            action = :command
    end

    @add_arg_table s["compute"] begin
        "--file", "-f"
            help = "An input file."
            arg_type = ASCIIString
            required = false
        "--dnaseqs", "-s"
            help = "The first of two DNA sequences to test"
            required = false
            arg_type = BioSequence{DNAAlphabet{4}}
            nargs = '*'
        "--model", "-m"
            help = """
            The model used to compute genetic distances.
            Currently jc69, and k80 are supported.
            """
            arg_type = ASCIIString
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
            arg_type = ASCIIString
            default = "default"
        "--outfile", "-o"
            help = "Base name for the output files(s)."
            default = "SpeedDate"
            arg_type = ASCIIString
        "--scan"
            help = "Whether or not to compute dates across sequences with a sliding window."
            action = :store_true
        "--width", "-w"
            help = "Width of the sliding window across sequences."
            arg_type = Int64
            default = 100
        "--step", "-j"
            help = "The number of base pairs the sliding window moves by each iteration."
            arg_type = Int64
            default = -1
        "--onlydist"
            action = :store_true
    end

    return parse_args(s)
end

function main()
    #try
        arguments = parse_command_line()
        if arguments["%COMMAND%"] == "compute"
            compute(arguments["compute"])
        end
    #catch err
        #(STDOUT, "SpeedDate could not complete analysis.\nReason:\n$(err.msg)\n")
    #end
end

end
