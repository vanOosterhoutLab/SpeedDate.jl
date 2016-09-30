
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
    setproperty!(μ_entry, :text, μ)
    push!(μ_box, μ_label)
    push!(μ_box, μ_entry)
    push!(assumptions_box, μ_box)
    push!(assumptions_frame, assumptions_box)
    g[1,2] = assumptions_frame

    ## Signals and behaviour

    fl = signal_connect(load_button, "clicked") do widget
        file = open_dialog("Choose a FASTA file", win, ("*.fas","*.fasta"))
        iostream = open(FASTAReader, file)
        try
            SEQUENCES = collect(iostream)
            info_dialog("Completed reading FASTA file!")
        catch
            error_dialog("Something went wrong reading in your file!")
        finally
            close(iostream)
        end
    end

    flen = signal_connect(len_button, "clicked") do widget
        println(length(SEQUENCES))
        println(getproperty(μ_entry, :text, String))
    end



    push!(win, g)
    showall(win)
    c = Condition()
    signal_connect(win, :destroy) do widget
        notify(c)
    end
    wait(c)
end
