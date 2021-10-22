declare Sum in

    fun {Sum List}
        fun {Iterate List Sum}
            case List of Head|Tail then
                {Iterate Tail Head + Sum}
            else
                Sum
            end
        end
    in
        {Iterate List 0}
    end


{Show {Sum [0 1 2 3 1 7 1]}}