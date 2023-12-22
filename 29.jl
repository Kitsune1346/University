function all_lab_marker(r::Robot)
    if ismarker(r)==false
        for side in (HorizonSide(i) for i=0:3)
            putmarker!(r)
            move!(r, side)
            all_lab_marker(r)
            move!(r, inverse(side))
        end
    end
end