using  HorizonSideRobots

HSR = HorizonSideRobots

abstract type AbstractRobot end

HSR.move!(robot::AbstractRobot, side) = move!(get_baserobot(robot), side)
HSR.isborder(robot::AbstractRobot, side) = isborder(get_baserobot(robot), side)
HSR.putmarker!(robot::AbstractRobot) = putmarker!(get_baserobot(robot))
HSR.ismarker(robot::AbstractRobot) = ismarker(get_baserobot(robot))
HSR.temperature(robot::AbstractRobot) = temperature(get_baserobot(robot))

abstract type AbstractDirectRobot <: AbstractRobot end


HSR.move!(robot::AbstractDirectRobot) = move!(get_baserobot(robot), get_direct(robot))

right(side::HorizonSide)=HorizonSide(mod(Int(side)+3, 4))
left(side::HorizonSide)=HorizonSide(mod(Int(side)+1, 4))
inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,  4))

DirectFunction = Union{
    typeof(left), 
    typeof(right), 
    typeof(inverse)
}

mutable struct DirectRobot{TypeRobot} <: AbstractDirectRobot
    robot::TypeRobot
    direct::HorizonSide
end

get_direct(robot::DirectRobot) = robot.direct
get_baserobot(robot::DirectRobot) = robot.robot

HSR.isborder(robot::AbstractDirectRobot, direct::DirectFunction) = isborder(get_baserobot(robot), direct(robot.direct))
HSR.isborder(robot::AbstractDirectRobot) = isborder(robot, get_direct(robot))

HSR.move!(robot::AbstractDirectRobot) = move!(get_baserobot(robot), get_direct(robot))

along!(direct_robot::DirectRobot) = while try_move!(direct_robot) end
try_move!(direct_robot::DirectRobot) = (move!(get_baserobot(direct_robot), get_direct(direct_robot)); true)

function turn!(robot::DirectRobot, direct::DirectFunction)::Nothing 
    robot.direct = direct(robot.direct)
    return nothing
end

@enum Оrientation Positive=0 Negative=1

inverse(orientation::Оrientation) = Оrientation(mod(Int(orientation)+1, 2))

mutable struct EdgeRobot{TypeRobot} <: AbstractDirectRobot
    direct_robot::DirectRobot{TypeRobot}
    orientation::Оrientation

    function EdgeRobot{TypeRobot}(robot::TypeRobot, edge_start_side::HorizonSide, orientation::Оrientation=Positive) where TypeRobot
        # Робота надо развернуть в соответствии с заданным направлением обхода границы (orientation),  
        # так, чтобы он мог сделать шаг вперед вдоль границы
        if orientation == Positive
            rot_fun = left #в какую сторону нужно перемещать робота
            inv_rot_fun = right
        else # orientation == Negative
            inv_rot_fun = left   
            rot_fun = right
        end
        direct_side = edge_start_side # Nord
   	    direct_robot = DirectRobot{TypeRobot}(robot, direct_side)
        n=0
        while !isborder(direct_robot) && n < 4
            turn!(direct_robot, rot_fun)
            n += 1
        end
        if !isborder(direct_robot)
            throw("Рядом с роботом отсутствует перегородка")
        end
        n = 0
        while isborder(direct_robot) && n < 4
            turn!(direct_robot, inv_rot_fun)
            n += 1
        end
        if isborder(direct_robot)
            throw("Робот ограничен со всех 4-х сторон")
        end
        #УТВ: Слева от робота перегородка и он может сделать шаг вперед
        return new(direct_robot, orientation)
    end
end

get_baserobot(robot::EdgeRobot) = get_baserobot(robot.direct_robot) # возвращает TypeRobot
get_direct(robot::EdgeRobot)::HorizonSide = get_direct(robot.direct_robot) # возвращает направление DirectRobot{TypeRobot}
get_orientation(robot::EdgeRobot)::Orientation = robot.orientation

along!(stop_condition::Function, edge_robot::EdgeRobot) = while !stop_condition() 
    move!(edge_robot) 
end

along!(edge_robot::EdgeRobot, num_steps) = for _ in 1:num_steps 
    move!(edge_robot) 
end

function inverse!(robot::EdgeRobot)::Nothing 
    if robot.orientation == Positive
        #=
        Дано: слева - перегородка (или её нет, если только  робот - на углу), спереди - свободно
        Требуется: справа - перегородка (или её нет, если только робот - на углу), спереди - свободно
        =#    
        turn!(robot.direct_robot, left)
        while isborder(robot.direct_robot) # если только робот - на углу, то цикл невыполняется ни разу 
            turn!(robot.direct_robot, left)
        end
    else # robot.orientation == Negative
        # аналогично ...
        turn!(robot.direct_robot, right)
        while isborder(robot.direct_robot)
            turn!(robot.direct_robot, right)
        end
    end 
    robot.orientation = inverse(robot.orientation)
    return nothing
end

function HSR.move!(robot::EdgeRobot)::Nothing
    function turns!(turn_direct::Function, inv_turn_direct::Function)
        # Разворачивает робота так, чтобы слева/справа была граница, а спереди - свободно
        if !isborder(robot.direct_robot, turn_direct)
            turn!(robot.direct_robot, turn_direct)
        else
            while isborder(robot.direct_robot)
                turn!(robot.direct_robot, inv_turn_direct)
            end
        end
        return nothing 
    end
    move!(robot.direct_robot)  # - смещеает робота вперед на 1 клетку в направлении robot.direct_robot.direct
    # Далее выполняется разворот:
    if robot.orientation == Positive
        turns!(left, right) # УТВ: cлева - граница, спереди - свободно
    else # orientation == Negative 
        turns!(right, left) # УТВ: cправа - граница, спереди - свободно
    end 
    return nothing
end

r=EdgeRobot{Robot}(Robot(animate=true, "border.sit"), Nord)