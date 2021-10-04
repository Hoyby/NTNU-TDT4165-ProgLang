% Takes a string and returns a list of those elements seperated at the spaces.
% Input  String
% Output Array of lexemes (ASCII)
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
fun {Interpret Tokens}

    Ops = operators( % Define operations
        plus: fun {$ X Y} X + Y end
        minus: fun {$ X Y} X - Y end
        multiply: fun {$ X Y} X * Y end
        divide: fun {$ X Y} X / Y end
    )

    Cmds = commands( % Define commands
        print: fun {$ X} {Show {List.reverse X}} X end
        duplicate: fun {$ X} X.1 | X end
        flip: fun {$ X} case X of number(Head)|Tail then number(~Head) | Tail end end
        inverse: fun {$ X} case X of number(Head)|Tail then number((1.0/Head)) | Tail end end
    )

    % Create stack 
    fun {ProcStack Tokens Stack}
        case Tokens of nil then % Check if TokenList is empty, if yes, result should be at top of stack
            {List.reverse Stack} % Returns the stack in reverse


        [] operator(type:Op) | Tail then % Check first element for operator
            case Stack of number(Num2) | number(Num1) | StackRest then % Pull two numbers from top of stack
                {ProcStack Tail number({Ops.Op Num1 Num2})|StackRest} % Perform operation defined in Ops add result to stack
            else nil end


        [] command(Cmd) | Tail then % Check first element for command
            
            {ProcStack Tail {Cmds.Cmd Stack}} % Perform operation defined in Ops add result to stack


        [] number(N) | Tail then % Check first element for number
            {ProcStack Tail number(N)|Stack} % Add number to stack

        else raise "error" end 
        end
    end
in
    {ProcStack Tokens nil}
end


/* Individual tests:

{Show {Lex "1 2 + 3 *"}}
% returns: [[49] [50] [43] [51] [42]]

{Show {Tokenize {Lex "1 2 + 3 *"}}}
% returns: [number(1) number(2) operator(type:plus) number(3) operator(type:multiply)]

{Show {Interpret {Tokenize {Lex "1 2 3 +"}}}}
% returns: [number(1) number(5)]

{Show {Interpret {Tokenize {Lex "1 2 3 p +"}}}}
% prints: [number(1) number(2) number(3)]
% returns: [number(1) number(5)]

{Show {Interpret {Tokenize {Lex "1 2 3 + d"}}}}
% returns: [number(1) number(5) number(5)]

{Show {Interpret {Tokenize {Lex "1 2 3 + i"}}}}
% returns: [number(1) number(~5)]

{Show {Interpret {Tokenize {Lex "1 2 3 + ^"}}}}
% returns: [number(1) number(0.2)]

*/

% Full test:
% (((1 + 2) * 3) + 1) = 10 | inverse(10 / 2) = 0.2 | 0.2 * 5 = 1 | 1 - (-1) = 2
{Show {Interpret {Tokenize {Lex "1 2 + 3 * 1 + 2 / ^ 5 * d i - p"}}}}
% % prints: [number(2)]