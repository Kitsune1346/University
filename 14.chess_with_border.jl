using HorizonSideRobots
r=Robot(animate=true, "border.sit")

function putchessmarker(r::Robot)
    putmarker!(r)
    state=1
    num_Ost, state=num_side(r, West, state)
    num_Sud, state=num_side(r, Sud, state)
    move_side=Ost
    row_side=Nord
    snake!(()->isborder(r, row_side), r, move_side, row_side, state)
    along(r, West)
    along(r, Sud)
    along_num!(r, Ost, num_Ost)
    along_num!(r, Nord, num_Sud)
end

function num_side(r::Robot, side::HorizonSide, state)
    num_s=0
    flag, num=try_move(r, side)
    while flag==true
        if num%2==0
            state=other(state)
        end
        num_s+=1
        state=chessmarker(state)
        flag, num=try_move(r, side)
    end
    return num_s, state
end

function chessmarker(state)
    if state==0
        putmarker!(r)
    end
    state=other(state)
end

function snake!(stop_condition::Function, r::Robot, side::HorizonSide, side_nextrow::HorizonSide, state)
    state=along!(()->stop_condition() || isborder(r, side), r, side, state)
    flag=true
    while stop_condition()==false && flag==true
        flag, num=try_move(r, side_nextrow)
        state=chessmarker(state)
        side=inverse(side)
        state=along!(()->stop_condition() || isborder(r, side), r, side, state)
    end
end

function try_move(r::Robot, side::HorizonSide)
    n=0
    num=0
    if isborder(r, side)==true
        while isborder(r, side)==true
            if isborder(r, left(side))==true && isborder(r, side)==true
                move(r, right(side), n)
                return false, 0
            end
            move!(r, left(side))
            n+=1
        end
        move!(r, side)
        num+=1
        while isborder(r, right(side))==true
            move!(r, side)
            num+=1
        end
        move(r, right(side), n)
    else
        move!(r, side)
        num+=1
    end
    return true, num
end

function along!(stop_condition::Function, r::Robot, side::HorizonSide, state::Integer)
    flag, num=try_move(r, side)
    while flag==true || stop_condition()==false
        if num%2==0
            state=other(state)
        end
        state=chessmarker(state)
        flag, num=try_move(r, side)
    end
    return state
end

function along(r::Robot, side::HorizonSide)
    while isborder(r, side)==false
        move!(r, side)
    end
end

function along_num!(r::Robot, side::HorizonSide, num::Integer)
    while num!=0
        move!(r, side)
        num-=1
    end
end

other(state)=(mod((state+1), 2))
right(side::HorizonSide)=HorizonSide(mod(Int(side)+1, 4))
left(side::HorizonSide)=HorizonSide(mod(Int(side)+3, 4))
inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,  4))
