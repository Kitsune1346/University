using HorizonSideRobots
r=Robot(animate=true, "border.sit")

function double_distans(r::Robot, side::HorizonSide)
    if isborder(r, side)
        try_move_recursia(r, side)
        return
    end
    move!(r, side)
    double_distans(r, side)
    move!(r, side)
end

function try_move_recursia(r::Robot, side::HorizonSide)
    if isborder(r, side::HorizonSide)==false
        move!(r, side::HorizonSide)
        return
    end
    move!(r, right(side))
    try_move_recursia(r::Robot, side::HorizonSide)
    move!(r, left(side))
end

right(side::HorizonSide)=HorizonSide(mod(Int(side)+1, 4))
left(side::HorizonSide)=HorizonSide(mod(Int(side)+3, 4))