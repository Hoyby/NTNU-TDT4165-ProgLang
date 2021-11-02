declare GenerateOdd Product in

    fun {GenerateOdd S E}
        if S =< E then % Input check
            if {Int.isOdd S} then % If number is odd
                S|{GenerateOdd S+2 E} % Add to result, next odd should be at n+2
            else
                {GenerateOdd S+1 E} % Else n+1 should be odd
            end
        else nil end
    end

    fun {Product S}
        case S of Head|Tail then
            Head * {Product Tail}
        else
            1
        end
    end
    


local Numbers Prod in
    thread Numbers = {GenerateOdd 0 1000} end
    thread Prod = {Product Numbers} end
    {System.showInfo Prod}
end

