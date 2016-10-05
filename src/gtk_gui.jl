
function start_interactive_app()
    # Application Data
    SEQUENCES = Vector{DNASequence}()
    μ = "10e-9"

    # User interface
    win = @Window("Speed Date")

    g = @Grid()

    ## Load and Saving data buttons
    data_frame = @Frame("Data")
    data_button_box = @ButtonBox(:h)
    load_button = @Button("Load FASTA file")
    len_button = @Button("Length")
    push!(data_frame, data_button_box)
    push!(data_button_box, load_button)
    push!(data_button_box, len_button)
    g[1,1] = data_frame

    ## Calculation and model assumptions
    assumptions_frame = @Frame("Assumptions")
    assumptions_box = @Box(:v)
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
    push!(assumptions_frame, assumptions_box)
    push!(assumptions_box, model_frame)
    push!(model_frame, model_box)
    push!(model_box, JC69_radio)
    push!(model_box, K80_radio)
    push!(model_box, μ_box)
    g[1,3] = assumptions_frame


    ## Sliding window settings
    window_frame = @Frame("Sliding Window")
    window_box = @Box(:v)
    slide_check = @CheckButton("Use Sliding Windows")

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

    flen = signal_connect(len_button, "clicked") do widget
        println(length(SEQUENCES))
        println(getproperty(μ_entry, :text, String))
    end



    push!(win, g)
    setproperty!(g, :column_spacing, 15)
    setproperty!(g, :row_spacing, 15)
    setproperty!(g, :column_homogeneous, true)
    showall(win)
    c = Condition()
    signal_connect(win, :destroy) do widget
        notify(c)
    end
    wait(c)
end
