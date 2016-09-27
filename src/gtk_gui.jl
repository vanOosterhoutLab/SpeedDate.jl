
function start_interactive_app()
    win = @Window("Speed Date")



    c = Condition()
    signal_connect(win, :destroy) do widget
        notify(c)
    end
    wait(c)
end
