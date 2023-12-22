using HorizonSideRobots

function fibb(n::Number)
    a, b=1
    while n!=0
        a, b=b, a+b
        n-=1
    end
    return a
end