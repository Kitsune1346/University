using HorizonSideRobots

function fibb_rec(n::Number)
    if n in (0, 1)
        return 1
    end
        return fibb_rec(n-2)+fibb_rec(n-1)
end