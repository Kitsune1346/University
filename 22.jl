using HorizonSideRobots
r=Robot(animate=true)

function along_with_rekursia3(r::Robot, side::HorizonSide)
    if isborder(r, side)
        return
    end
    move!(r, side)
    along_with_rekursia3(r, side)
    for _ in 0:1
        if isborder(r, inverse(side))
            return false
        end
        move!(r, inverse(side))
    end
    return true
end

inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,  4))