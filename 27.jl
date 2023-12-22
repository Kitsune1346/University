using HorizonSideRobots

function summa(array::Vector{T}, s::T=0) where T
    if length(array)==0
        return s
    else
        return summa(@view(array[1:end-1]), s+array[end])
    end
end