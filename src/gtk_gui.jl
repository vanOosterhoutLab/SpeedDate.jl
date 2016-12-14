
using Gtk.ShortNames

function start_interactive_app()

    # User interface
    win = @Window("Speed Date")

    g = @Grid()

    ## Action buttons
    go_button = @Button("Go!")
    g[1, 1] = go_button

    ## Calculation and model assumptions
    μ_box = @Box(:h)
    μ_label = @Label("Mutation Rate:")
    μ_entry = @Entry()
    model_frame = @Frame("Mutation Model")
    model_box = @Box(:v)
    JC69_radio = @RadioButton("Jukes Cantor 69")
    K80_radio = @RadioButton(JC69_radio, "Kimura 80")
    setproperty!(μ_entry, :text, "10e-9")
    push!(μ_box, μ_label)
    push!(μ_box, μ_entry)
    push!(model_frame, model_box)
    push!(model_box, JC69_radio)
    push!(model_box, K80_radio)
    push!(model_box, μ_box)
    g[1, 2] = model_frame


    ## Sliding window settings
    window_frame = @Frame("Sliding Window")
    slide_check = @CheckButton("Use Sliding Windows")
    size_label = @Label("Window Size")
    size_entry = @Entry()
    step_label = @Label("Step Size")
    step_entry = @Entry()
    wg = @Grid()
    setproperty!(g, :column_homogeneous, true)
    wg[1,1] = slide_check
    wg[1,2] = size_label
    wg[2,2] = size_entry
    wg[1,3] = step_label
    wg[2,3] = step_entry
    push!(window_frame, wg)
    g[1, 3] = window_frame
    setproperty!(size_entry, :text, "1000")
    setproperty!(step_entry, :text, "1")


    ## Signals and behaviour

    gosig = signal_connect(go_button, "clicked") do widget
        try
            args = Dict{String, Any}()
            args["file"] = open_dialog("Choose a FASTA file", win, ("*.fas","*.fasta"))
            args["model"] = getproperty(JC69_radio, :active, Bool) ? "jc69" : "k80"
            args["method"] = "default"
            args["scan"] = getproperty(slide_check, :active, Bool)
            args["width"] = parse(Int64, getproperty(size_entry, :text, String))
            args["step"] = parse(Int64, getproperty(step_entry, :text, String))
            args["mutation_rate"] = parse(Float64, getproperty(μ_entry, :text, String))
            args["outfile"] = save_dialog("Enter a basename for results files", win)
            args["onlydist"] = false
            compute(args)
        catch e
            error_dialog("SpeedDate could not complete analysis.\nReason:\n$(e.msg)\n", win)
        end
    end

    push!(win, g)
    setproperty!(g, :row_spacing, 15)
    showall(win)
    c = Condition()
    signal_connect(win, :destroy) do widget
        notify(c)
    end
    wait(c)
end
