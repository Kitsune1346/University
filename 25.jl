using HorizonSideRobots
r=Robot(animate=true)

function marker_recursia(r::Robot, side::HorizonSide) 
    if isborder(r, side)==false
        putmarker!(r)
        move!(r, side)
        notmarker_recursia(r, side)
    end
end

function notmarker_recursia(r::Robot, side::HorizonSide)
    if isborder(r, side)==false
        move!(r, side)
        putmarker!(r)
        marker_recursia(r, side)
    end
end
