declare Sum in

    fun {Sum List}
        case List of Head | Tail then
            Head + {Sum Tail}
        [] nil then
            0
        end
    end

{Show {Sum [0 1 2 3 1 7 1]}}