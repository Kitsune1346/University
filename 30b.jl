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

r=CoordsRobot(Robot(animate=true), 0, 0)

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

struct LabirintRobot
    robot::CoordsRobot
    passed_coordinates::Set
    LabirintRobot(robot) = new(CoordsRobot(robot), Set())
end

function labirint!(robot::CoordsRobot)
    passed_coordinates=Set{}()
    state=0
    function recurcia_tranversal!()
        if get_coords(robot) ∉ passed_coordinates
            push!(passed_coordinates, get_coords(robot))
            for side ∈ (Nord, West, Sud, Ost)
                if isborder(r, side)==false
                    state=chess(state)
                    move!(robot, side)
                    recurcia_tranversal!()
                    state=chess(state)
                    move!(robot, inverse(side))
                end
            end
        end
    end
    recurcia_tranversal!()
end

function chess(state)
    if state==0
        putmarker!(r)
    end
    state=other(state)
end

inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,  4))
other(state)=(mod((state+1), 2))