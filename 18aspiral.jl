using HorizonSideRobots
r=Robot(animate=true, "untitled.sit")

function spiral(stop_condition::Function, r::Robot)
    side=Nord
    n=1
    iss_odd=false
    while stop_condition()==false
        for _ in 1:n
            try_move!(r, side)
            if stop_condition()==true
                return true
            end
        end
        if iss_odd==true 
            n+=1
        end
        side=left(side)
        iss_odd=!iss_odd
    end
end

function try_move!(r::Robot, side::HorizonSide)
    n=0
    if isborder(r, side)==true
        while isborder(r, side)==true
            move!(r, left(side))
            n+=1
            if isborder(r, left(side))==true && isborder(r, side)==true
                move(r, right(side), n)
                return false
            end
        end
        move!(r, side)
        while isborder(r, right(side))==true
            move!(r, side)
        end
        move(r, right(side), n)
    else
        move!(r, side)
    end
    return true
end

function move(r, side, num)
    while num!=0
        move!(r, side)
        num-=1
    end
end

right(side::HorizonSide)=HorizonSide(mod(Int(side)+1, 4))
left(side::HorizonSide)=HorizonSide(mod(Int(side)+3, 4))
inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,  4))