using HorizonSideRobots
r=Robot(animate=true)

function shuttle(stop_condition::Function, r, side)
    i=0
    while stop_condition()==false
        i+=1
        along(r, side, i)
        side=inverse(side)
    end
    move!(r, Nord)
    if i%2==0
        along_num!(r, side, i÷2)
    else
        along_num!(r, side, (i+1)÷2)
    end
end

function along_num!(r::Robot, side::HorizonSide, n)
    while n!=0
        move!(r, side)
        n-=1
    end
end
inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,  4))