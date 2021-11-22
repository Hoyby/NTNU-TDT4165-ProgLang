payment(0, []).
payment(Sum, [coin(Type,Value,Available)|Tail]) :-
    Type in 0..Available,
    Sum #= Value*Type + TailTotal,
    payment(TailTotal, Tail).