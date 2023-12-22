using HorizonSideRobots
r=Robot(animate=true)

function along_with_rekursia20(r::Robot, side::HorizonSide)
    if isborder(r, side)
        putmarker!(r)
        return
    end
    move!(r, side)
    along_with_rekursia20(r, side)
    move!(r, inverse(side))
end

inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,  4))