
function start_interactive_app()
    ### Application Data
    SEQUENCES = Vector{DNASequence}()

    ### User interface
    win = @Window("Speed Date")
    file_frame = @Frame()
    assumptions_frame = @Frame("Assumptions")

    load_button = @Button("Load FASTA file")
    push!(win, load_button)
    len_button = @Button("Length")
    push!(win, len_button)



    ### Signals and behaviour

    fl = signal_connect(load_button, "clicked") do widget
        file = open_dialog("Choose a FASTA file", win, ("*.fas","*.fasta"))
        SEQUENCES = collect(open(FASTAReader, file))
    end

    flen = signal_connect(len_button, "clicked") do widget
        println(length(SEQUENCES))
    end




    showall(win)
    c = Condition()
    signal_connect(win, :destroy) do widget
        notify(c)
    end
    wait(c)
end
