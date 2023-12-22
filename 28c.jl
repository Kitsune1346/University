function memoize_fibonacci(n::Integer)
    dict = Dict{Int,Int}()
    function fib_recurs(n)
        if n in (0,1)
            return 1
        end
        if n-2 ∉ dict.keys
            b = fib_recurs(n-2)
        else
            b = dict[n-2]
        end
        if n-1 ∉ dict.keys
            a = fib_recurs(n-1)
        else
            a = dict[n-1]
        end
        return b+a
    end
end