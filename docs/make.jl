using Documenter, SpeedDate, Pkg

makedocs(
    modules = [SpeedDate],
    format = Documenter.HTML(),
    sitename = "SpeedDate.jl",
    authors = replace(join(Pkg.TOML.parsefile("Project.toml")["authors"], ", "), r" <.*?>" => "" ),
    pages = [
        "Home" => "index.md",
        "Manual" => [
            "Introduction" => "man/intro.md",
            "Loading Data" => "man/loading.md",
            "Dating Sequences" => "man/dating.md"
        ]
    ]
)

deploydocs(
    repo = "github.com/vanOosterhoutLab/SpeedDate.jl.git",
    push_preview = true,
    deps = nothing,
    make = nothing
)
