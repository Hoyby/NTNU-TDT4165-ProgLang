declare Quadratic in

    fun {Quadratic A B C}
        fun {Calculate X}
            A*X*X + B*X + C
        end
    in
        Calculate
    end
    
{Show {{Quadratic 3 2 1} 2}}