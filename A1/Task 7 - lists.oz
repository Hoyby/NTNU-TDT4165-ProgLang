declare fun {Lenght List}
    case List of Head | Tail then
        1 + {Lenght Tail}
    [] nil then
        0
    end
end
{Show {Lenght [0 1 1 1 1 1 1]}}


declare fun {Take List Count}
    if Count > 0 then
        case List of Head | Tail then
            Head|{Take Tail Count-1}
        [] nil then
            nil
        end
    else
        nil
    end

end
{Show {Take [0 1 2 3 4 5 6] 3}}


declare fun {Drop List Count}
    if Count > 0 then
        case List of Head | Tail then
            {Drop Tail Count-1}
        [] nil then
            nil
        end
    else
        List
    end

end
{Show {Drop [0 1 2 3 4 5 6] 3}}


declare fun {Append List1 List2}
        case List1 of Head | Tail then
            Head | {Append Tail List2}
        [] nil then
            List2
    end

end
{Show {Append [0 1 2 3] [4 5 6]}}


declare fun {Member List Element}
        case List of Head | Tail then
            if Head == Element then
                true
            else
                {Member Tail Element}
            end
        [] nil then
            false
    end

end
{Show {Member [0 1 2 3 4 5 6] 3}}


declare fun {Position List Element}
        case List of Head | Tail then
            if Head == Element then
                0
            else
                1 + {Position Tail Element}
            end
    end
end
{Show {Position [0 1 2 7 4 3 6] 3}}

