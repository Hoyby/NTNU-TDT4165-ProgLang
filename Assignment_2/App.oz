%Input  String
%Output Array of lexemes (ASCII)
declare fun {Lex Input}
    {String.tokens Input 32} % Split at ASCII char 32 (space) and return as list.
end

% {Show {Lex "1 2 + 3 *"}}

%Input  Array of lexemes
%Output List of records in the form of: operator(type:OPERATOR) or number(N)
declare fun {Tokenize Lexemes} Token in
    case Lexemes of Head | Tail then % Read head.
        case Head of "+" then Token = operator(type:plus) % Check head for operator match.
            [] "-" then Token = operator(type:minus)
            [] "*" then Token = operator(type:multiply)
            [] "/" then Token = operator(type:divide)
        else Token = number({String.toFloat Head}) % No match found, Token must be number.
        end
        Token | {Tokenize Tail} % recursive call.

    else nil % end of list
    end
end

% {Show {Tokenize {Lex "1 2 + 3 *"}}}

%Input  List of records
%Output The stack
%Valid  +, -, *, and /, with / being floating point division.

    % Operators = operators( % Define record
    %     plus: fun {$ X Y} X + Y end
    %     minus: fun {$ X Y} X - Y end
    %     multiply: fun {$ X Y} X * Y end
    %     divide: fun {$ X Y} X / Y end
    % )

declare fun {Interpret Tokens} Operators in

    case Tokens of Head | Tail then
        case Head of operator(type:Op)|Tail then

            {Show "Head"}
        [] number(N)|Tail then
            {Show "tall"}

            % pop 2 from stack
            % perform opertaion type
            % put back on stack

            

            % put on stack
        else {Show "error"}
        end
        {Interpret Tail} % recurse
        
    % if nil (end of list) then return stack[0]
    else nil
    end

end

{Show {Interpret {Tokenize {Lex "1 2 + 3 *"}}}}