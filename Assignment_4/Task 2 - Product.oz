declare Product in

    fun {Product S}
        case S of Head|Tail then
            Head * {Product Tail}
        else
            1
        end
    end
    
    
{Show {Product [1 2 3 4]}}
