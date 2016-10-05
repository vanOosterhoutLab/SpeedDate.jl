
function start_interactive_app()
    # Application Data
    SEQUENCES = Vector{DNASequence}()
    μ = "10e-9"

    # User interface
    win = @Window("Speed Date")

    g = @Grid()

    ## Action buttons
    actions_frame = @Frame("Actions")
    button_box = @ButtonBox(:v)
    load_button = @Button("Load FASTA file")
    go_button = @Button("Go!")
    push!(actions_frame, button_box)
    push!(button_box, load_button)
    push!(button_box, go_button)
    g[1, 1] = actions_frame

    ## Calculation and model assumptions
    μ_box = @Box(:h)
    μ_label = @Label("Mutation Rate:")
    μ_entry = @Entry()
    model_frame = @Frame("Mutation Model")
    model_box = @Box(:v)
    JC69_radio = @RadioButton("Jukes Cantor 69")
    K80_radio = @RadioButton(JC69_radio, "Kimura 80")
    setproperty!(μ_entry, :text, μ)
    push!(μ_box, μ_label)
    push!(μ_box, μ_entry)
    push!(model_frame, model_box)
    push!(model_box, JC69_radio)
    push!(model_box, K80_radio)
    push!(model_box, μ_box)
    g[2, 1] = model_frame


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
    wg[2,2] = step_label
    wg[1,3] = size_entry
    wg[2,3] = step_entry
    push!(window_frame, wg)
    g[3, 1] = window_frame
    setproperty!(size_entry, :text, "1000")
    setproperty!(step_entry, :text, "1")


    ## Signals and behaviour

    fl = signal_connect(load_button, "clicked") do widget
        file = open_dialog("Choose a FASTA file", win, ("*.fas","*.fasta"))
        iostream = open(FASTAReader, file)
        try
            SEQUENCES = collect(iostream)
            info_dialog("Completed reading FASTA file!", win)
        catch
            error_dialog("Something went wrong reading in your file!", win)
        finally
            close(iostream)
        end
    end

    flen = signal_connect(go_button, "clicked") do widget
        println(length(SEQUENCES))
        println(getproperty(μ_entry, :text, String))
    end



    push!(win, g)
    setproperty!(g, :column_spacing, 15)
    showall(win)
    c = Condition()
    signal_connect(win, :destroy) do widget
        notify(c)
    end
    wait(c)
end
