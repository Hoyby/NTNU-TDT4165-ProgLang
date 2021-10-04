declare
fun {Lex Input}
    {String.tokens Input 32} % Split at ASCII char 32 (space) and return as list.
end



% Takes an Array of Lexemes and turns them into records.
% Input  Array of lexemes
% Output List of records in the form of: operator(type:OPERATOR) or number(N)
declare
fun {Tokenize Lexemes} Token in
    case Lexemes of Head | Tail then % Read head.
        case Head of "+" then Token = operator(type:plus) % Check head for operator match.
            [] "-" then Token = operator(type:minus)
            [] "*" then Token = operator(type:multiply)
            [] "/" then Token = operator(type:divide)
            [] "p" then Token = command(print)
            [] "d" then Token = command(duplicate)
            [] "i" then Token = command(flip)
            [] "^" then Token = command(inverse)

        else Token = number({String.toFloat Head}) % No match found, Token must be number.
        end
        Token | {Tokenize Tail} % recursive call.

    else nil % end of list
    end
end



% Takes an array of records and performes the defined operations on the numbers using a stack and RPN. Returns the result stack.
% Input  List of records defined as: operator(type:OPERATOR) or number(N)
% Output The result stack
declare
fun {Infix Tokens}

    Ops = operators( % Define operations
        plus: "+"
        minus: "-"
        multiply: "*"
        divide: "/"
    )

    Cmds = commands( % Define commands
        flip: "-"
        inverse: "1/"
    )

    % Create stack 
    fun {ProcStack Tokens Stack}

        case Tokens of number(N) | Tail then
            {ProcStack Tail N|Stack}

        [] operator(type:Op) | Tail then
            case Stack of Num1 | Num2 | RestStack then
                {ProcStack Tail "("#Num2#Ops.Op#Num1#")" | RestStack}
            else raise "error" end 
            end

        [] command(Cmd) | Tail then
            case Stack of Head | RestStack then
                {ProcStack Tail Cmds.Cmd#Head | RestStack}
            else raise "error" end 
            end

        [] nil then
            Stack

        else {Show Tokens} raise "error" end
        end
    end
in
    {ProcStack Tokens nil}
end


% Not sure why, but cant get it to print virtual strings.
{System.show {Infix {Tokenize {Lex "1 2 +"}}}}
{System.showInfo {Infix {Tokenize {Lex "1 2 +"}}}}