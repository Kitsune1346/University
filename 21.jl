using HorizonSideRobots
r=Robot(animate=true, "border.sit")

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