using  HorizonSideRobots
r=Robot(animate=true)

function num_border(r::Robot)
    num=0
    num_ost=num_side(r, Ost)
    num_sud=num_side(r, Sud)
    side=West
    while isborder(r, Nord)==false
        num+=along_with_num_borders(r, side)
        move!(r, Nord)
        side=inverse(side)
    end
    along!(r, side)
    along!(r, Ost)
    along!(r, Sud)
    along_num!(r, Nord, num_sud)
    along_num!(r, West, num_ost)
    return num
end
function along_with_num_borders(r::Robot, side::HorizonSide)
    n=0
    flag=false
    while isborder(r, side)==false
        move!(r, side)
        if isborder(r, Nord)==true
            flag=true
        end
        if flag==true && isborder(r, Nord)==false
            n+=1
            flag=false
        end
        
    end
    return n
end
function num_side(r::Robot, side::HorizonSide)
    n=0
    while isborder(r, side)==false
        move!(r, side)
        n+=1
    end
    return n
    
end
function along!(r::Robot, side::HorizonSide)
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
