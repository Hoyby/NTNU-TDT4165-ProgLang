%Input  String
%Output Array of lexemes (ASCII)
declare fun {Lex Input}
    {String.tokens Input 32}
    
end

{Show {Lex "1 2 + 3 *"}}

%Input  Array of lexemes
%Output List of records

%Records    operator(type:plus), 
%           operator(type:minus),
%           operator(type:multiply),
%           operator(type:divide), 
%           number(N) where N is any number
declare fun {Tokenize Lexemes}
    Lexemes
end


%Input  List of records
%Output The stack

%Valid  +, -, *, and /, with / being floating point division.
% declare fun {Interpret Tokens}

% end