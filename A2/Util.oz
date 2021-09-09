declare fun {Lenght List}
    case List of Head | Tail then
        1 + {Lenght Tail}
    [] nil then
        0
    end
end


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


declare fun {Append List1 List2}
        case List1 of Head | Tail then
            Head | {Append Tail List2}
        [] nil then
            List2
    end

end


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


declare fun {Position List Element}
        case List of Head | Tail then
            if Head == Element then
                0
            else
                1 + {Position Tail Element}
            end
    end
end
