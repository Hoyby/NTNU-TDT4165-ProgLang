declare RightFold Lenght Sum in

    fun {RightFold List Op U}

        % Check for- and split list into Head | Tail
        case List of Head | Tail then 

            % Call on the Op function with Head as the first parameter and the Head of the next recursive call. 
            % Because of the call stack, this will be performed from right to left
            {Op Head {RightFold Tail Op U}} 

        % If the case check is nil, then we're at the end of the list.
        [] nil then

            % We're returning the 'neutral' U value
            U

        % If none of the above something went wrong.
        else raise "error" end
        end
    end

    fun {Lenght List}
        {RightFold List fun {$ X Y} 1 + Y end 0}
    end

    fun {Sum List}
        {RightFold List fun {$ X Y} X + Y end 0}
    end

{Show{Sum [0 1 2 3 1 7 1]}}