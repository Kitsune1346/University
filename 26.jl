using HorizonSideRobots
r=Robot(animate=true)

function all_lab_marker(r::Robot)
    if ismarker(r)==false
        putmarker!(r)
        for side in (HorizonSide(i) for i=0:3)
            if isborder(r, side)==false 
                putmarker!(r)
                move!(r, side)
                all_lab_marker(r)
                move!(r, inverse(side))
            end
        end
    end
end

inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,  4))