using  HorizonSideRobots
HSR = HorizonSideRobots
abstract type AbstractRobot end

HSR.move!(robot::AbstractRobot, side) = move!(get_baserobot(robot), side)
HSR.isborder(robot::AbstractRobot, side) = isborder(get_baserobot(robot), side)
HSR.putmarker!(robot::AbstractRobot) = putmarker!(get_baserobot(robot))
HSR.ismarker(robot::AbstractRobot) = ismarker(get_baserobot(robot))
HSR.temperature(robot::AbstractRobot) = temperature(get_baserobot(robot))

abstract type AbstractCoordsRobot <: AbstractRobot end

mutable struct CoordsRobot <: AbstractCoordsRobot
    robot::Robot
    x::Int
    y::Int
end

r=CoordsRobot(Robot(animate=true, "border.sit"), 0, 0)

get_baserobot(robot::CoordsRobot) = robot.robot
get_coords(robot::CoordsRobot) = (robot.x, robot.y)
set_coords(robot::CoordsRobot, x, y) = (robot.x=x; robot.y=y; nothing) 

function HSR.move!(robot::AbstractCoordsRobot, side::HorizonSide)
   move!(get_baserobot(robot), side)
   x, y = get_coords(robot)
    if side==Nord
        set_coords(robot, x, y+1)
    elseif side==Sud
        set_coords(robot, x, y-1)
    elseif side==Ost
        set_coords(robot, x+1, y)
    else 
        set_coords(robot,x-1, y)
    end
end


function kosoy_krest(r::CoordsRobot)
    for side in (HorizonSide(i) for i=0:3)
        putmarkers!(r, side, left(side))
        move_by_markers(r, inverse(side), right(side))
    end
    putmarker!(r)
end

putmarkers!(r::CoordsRobot, side1::HorizonSide, side2::HorizonSide)=
while moved(r, side1, side2)
    putmarker!(r)
end
function moving(r::CoordsRobot, side::HorizonSide)
    if abs(r.x)!=abs(r.y)
        move!(r, inverse(side))
    end
end

function moved(r::CoordsRobot, side1::HorizonSide, side2::HorizonSide)
    if isborder(r, side1)==true
        if try_move(r, side2)==false || perimetr(()->check(r.x, r.y, side1), r, side1, side2)==false
            moving(r, side2)
            return false
        end
    else
        move!(r, side1)
    end
    if isborder(r, side2)==true
        if perimetr(()->check(r.x, r.y, side1), r, side2, side1)==false
            moving(r, side1)
            return false
        end
    elseif abs(r.x)!=abs(r.y) && isborder(r, side2)==false
        move!(r, side2)
    end
    return true
end

function check(x::Int, y::Int, side::HorizonSide)
    if (x==y && Int(side)%2==1) || (x==-y && Int(side)%2==0)
        return true
    else
        return false
    end
end

function perimetr(stop_condition::Function, r::CoordsRobot, side1::HorizonSide, side2::HorizonSide)
    if along!(()->stop_condition() || !isborder(r, side1), r, side2)==false
        return false
    end
    side1, side2=inverse(side2), side1
    while stop_condition()==false
        move!(r, side2)
        along!(()->stop_condition() || !isborder(r, side1), r, side2)
        side1, side2=inverse(side2), side1
    end
    return true
end

function along!(stop_condition::Function, r::CoordsRobot, side::HorizonSide)
    n=0
    while stop_condition()==false
        if try_move(r, side)==false
            move(r, inverse(side), n)
            return false
        else
            n+=1
        end
    end
    return true
end

function try_move(r::CoordsRobot, side::HorizonSide)
    if isborder(r, side)==true
        return false
    end
    move!(r, side)
    return true
end

move_by_markers(r::CoordsRobot, side1::HorizonSide, side2::HorizonSide)=
while ismarker(r)==true
    moved(r, side1, side2)
end

function move(r::CoordsRobot, side::HorizonSide, num::Integer)
    while num!=0
        move!(r, side)
        num-=1
    end
end

right(side::HorizonSide)=HorizonSide(mod(Int(side)+3, 4))
left(side::HorizonSide)=HorizonSide(mod(Int(side)+1, 4))
inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,  4))