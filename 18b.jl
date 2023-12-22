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
        shuttle(()->!isborder(r, side), r, left(side))
    else
        move!(r, side)
    end
    return true
end

function shuttle(stop_condition::Function, r, side)
    i=0
    while stop_condition()==false
        i+=1
        move(r, side, i)
        side=inverse(side)
    end
    move!(r, Nord)
    if i%2==0
        move(r, side, i÷2)
    else
        move(r, side, (i+1)÷2)
    end
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