using Documenter, SpeedDate

custom_deps() = run(`pip install --user pygments mkdocs mkdocs-biojulia`)
makedocs()
deploydocs(
           repo = "github.com/Ward9250/SpeedDate.jl.git",
           julia = "0.5",
           osname = "linux",
           deps = custom_deps
           )
