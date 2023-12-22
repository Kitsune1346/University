using HorizonSideRobots
r=Robot(animate=true)

function marker_rec(r::Robot, n=0)
    if ismarker(r)==false
        for side in (HorizonSide(i) for i=0:3)
            if isborder(r, side)==false 
                if n==0
                    putmarker!(r)
                end
                move!(r, side)
                marker_rec(r, other(n))
                move!(r, inverse(side))
            end
        end
    end
end

function other(n)
    if n==0
        n=1
    else
        n=0
    end
    return n
end

inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,  4))