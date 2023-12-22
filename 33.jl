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

r=Robot(animate=true, "border.sit")

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

mutable struct LabirintRobot
    robot::CoordsRobot
    passed_coordinates::Set
    LabirintRobot(robot) = new(CoordsRobot(robot, 0, 0), Set())
end


function labirint!(stop_condition::Function, robot)
    passed_coordinates=Set{}()

    function recurcia_tranversal!()
        stop_condition()
        if get_coords(robot) ∉ passed_coordinates
            push!(passed_coordinates, get_coords(robot))
            for side ∈ (Nord, West, Sud, Ost)
                if isborder(r, side)==false
                    move!(robot, side)
                    recurcia_tranversal!()
                    move!(robot, inverse(side))
                end
            end
        end
    end
    recurcia_tranversal!()
end

function move_to_max_temperature!(robot::Robot)
    max_tmpr = max_temperature!(robot)
    passed_coordinates=0
    try
        labirint!(CoordsRobot(robot, 0, 0)) do
            if temperature(robot) == max_tmpr
                throw("temperature(robot)==max")
            end
        end
    catch
        return
    end
end

function max_temperature!(robot::Robot)
    max_tmpr = temperature(robot)
    labirint!(CoordsRobot(robot, 0, 0)) do
        if temperature(robot) > max_tmpr
            max_tmpr = temperature(robot)
        end
    end
    return max_tmpr
end

inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,  4))