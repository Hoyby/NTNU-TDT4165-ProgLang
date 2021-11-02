declare GenerateOdd in

    fun {GenerateOdd S E}
        if S =< E then % Input check
            if {Int.isOdd S} then % If number is odd
                S|{GenerateOdd S+2 E} % Add to result, next odd should be at n+2
            else
                {GenerateOdd S+1 E} % Else n+1 should be odd
            end
        else nil end
    end
    
{Show {GenerateOdd ~3 10}} % [-3 -1 1 3 5 9]
{Show {GenerateOdd 3 3}} % [3]
{Show {GenerateOdd 2 2}} % nil
