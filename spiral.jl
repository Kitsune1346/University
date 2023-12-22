using HorizonSideRobots
r=Robot(animate=true)

function spiral(stop_condition::Function, r::Robot)
    side=Nord
    n=1
    iss_odd=false
    while stop_condition()==false
        for _ in 1:n
            move!(r, side)
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

left(side::HorizonSide)=HorizonSide(mod(Int(side)+1, 4))