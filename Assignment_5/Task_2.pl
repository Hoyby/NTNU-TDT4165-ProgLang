:- use_module(library(clpfd)).
distance(c1, c2, 10, 1). distance(c1, c3, 0, 0). distance(c1, c4, 7, 1). distance(c1, c5, 5, 1). 
distance(c2, c1, 10, 1). distance(c2, c3, 4, 1). distance(c2, c4, 12, 1). distance(c2, c5, 20, 1). 
distance(c3, c1, 0, 0). distance(c3, c2, 4, 1). distance(c3, c4, 0, 0). distance(c3, c5, 0, 0). 
distance(c4, c1, 7, 1). distance(c4, c2, 12, 1). distance(c4, c3, 0, 0). distance(c4, c5, 0, 0). 
distance(c5, c1, 5, 1). distance(c5, c2, 20, 1). distance(c5, c3, 0, 0). distance(c5, c4, 0, 0).

plan(Start,End,Path,Dist) :-
    travel(Start,End,[Start],Q, Dist),
    reverse(Q,Path).

travel(Start,End,P,[End|P],Dist) :- 
    distance(Start,End,Dist,1).

travel(Start,End,Visited,Path,Dist) :-
    distance(Start,Node,D1,1),   				% Start and Node are connected        
    Node \== End, 								% Node is not end
    \+member(Node,Visited),						% Node har not been visited
    travel(Node,End,[Node|Visited],Path,D2),  	% Recurse with Node as start
	Dist is D1 + D2.

bestplan(Start, End, Path, Dist) :-
   	setof([Path,Dist],plan(Start,End,Path,Dist),Set),
   	Set = [_|_],                                % fail if empty
   	minimal(Set,[Path,Dist]).

minimal([F|R],M) :- min(R,F,M).

min([],M,M).
min([[P,L]|R],[_,M],Min) :- L < M, !, min(R,[P,L],Min). 
min([_|R],M,Min) :- min(R,M,Min).

% Inspo: https://www.cpp.edu/~jrfisher/www/prolog_tutorial/2_15.html


% Query: plan(c1,c2,Path,Dist).
%
% Path:             Dist:
% [c1, c2]	        10
% [c1, c4, c2]	    19
% [c1, c5, c2]	    25


% Query: bestplan(c1,c2,Path,Dist).
%
% Path:             Dist:
% [c1, c2]	        10