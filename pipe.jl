ccall(:jl_exit_on_sigint, Nothing, (Cint,), 0)

try
    mkfifo = open("pipe_a", "w") do io
        print(io,"")
    end
    pipe_a = open("pipe_a", "r")

    while true
        msg = read(pipe_a, String)
        if length(msg) > 0
            pipe_b = open("pipe_b", "w+")
            write(pipe_b, msg)
            close(pipe_b)
            println(msg)
        end
        sleep(1)
    end
catch e
    if isa(e, InterruptException)
        println("it was an interrupt")
    end    
finally
    rm("pipe_a")
    rm("pipe_b")
end