using  HorizonSideRobots
r=Robot(animate=true, "untitled.sit")

function putchessmarker(r::Robot)
    putmarker!(r)
    state=1
    num_Ost, state=num_side(r, Ost, state)
    num_Sud, state=num_side(r, Sud, state)
    move_side=West
    row_side=Nord
    while isborder(r, move_side)==false
        move!(r, move_side)
        state=chessmarker(state)
    end
    move_side=inverse(move_side)
    while isborder(r, row_side)==false 
        snake(r, move_side, row_side, state)
        move_side=inverse(move_side)
    end
    along!(r, Ost)
    along!(r, Sud)
    along_num!(r, West, num_Ost)
    along_num!(r, Nord, num_Sud)
end

function num_side(r::Robot, side::HorizonSide, state)
    num=0
    while isborder(r, side)==false
        move!(r, side)
        num+=1
        state=chessmarker(state)
    end
    return num, state
end

function chessmarker(state)
    if state==0
        putmarker!(r)
    end
    state=other(state)
end

function snake(r::Robot, move_side::HorizonSide, nextrow_side::HorizonSide, state)
    move!(r, nextrow_side)
    state=chessmarker(state)
    while isborder(r, move_side)==false
        move!(r, move_side)
        state=chessmarker(state)
    end
end

function along!(r, side) 
    while isborder(r, side)==false
        move!(r, side)
    end
end

function along_num!(r::Robot, side, num)
    while num!=0
        move!(r::Robot, side)
        num-=1
    end
end

inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,  4))
other(state::Int)=(mod((state+1), 2))
