using HorizonSideRobots
r=Robot(animate=true)

function half_dist(r::Robot, side::HorizonSide) 
    if isborder(r, side)==false
        move!(r, side)
        half_distance(r, side)
        move!(r, inverse(side))
    end
end

function half_distance(r::Robot, side::HorizonSide)
    if isborder(r, side)==false
        move!(r, side)
        half_dist(r, side)
    end
end

inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,  4))