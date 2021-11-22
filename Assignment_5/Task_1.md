```
:- use_module(library(clpfd)).  % Prolog library for Constraint Logic Programming.
                                % Necessary for all programs this chapter.
```

# 12 Constraint Programming

by Peter Van Roy, Raphaël Collet, and Seif Haridi.

This excerpt from "Concepts, Techniques, and Models of Computer Programming", MIT Press, 2004, is
revised for use with CLP(FD) and published electronically as a notebook in SWISH
with consent from the authors. ("SWISH: SWI-Prolog for Sharing"
Jan Wielemaker, Torbjörn Lager, Fabrizio Riguzzi, https://arxiv.org/abs/1511.00915)

```
Plans within plans within plans within plans. (Dune, Frank Herbert (1920–1986))
```

### Introduction

Constraint programming consists of a set of techniques for solving constraint
satisfaction problems. A constraint satisfaction problem, or CSP, consists of a set
of constraints on a set of variables. A constraint, in this setting, is simply a logical
relation, such as “X is less than Y” or “X is a multiple of 3.” The first problem
is to find whether there exists a solution, without necessarily constructing it. The
second problem is to find one or more solutions.
A CSP can always be solved with brute force search. All possible values of all
variables are enumerated and each is checked to see whether it is a solution. Except
in very small problems, the number of candidates is usually too large to enumerate
them all. Constraint programming has developed “smart” ways to solve CSPs which
greatly reduce the amount of search needed. This is sufficient to solve many practical
problems. For many problems, though, search cannot be entirely eliminated. Solving
CSPs is related to deep questions of intractability. Problems that are known to be
intractable will always need some search. The hope of constraint programming is
that, for the problems that interest us, the search component can be reduced to an
acceptable level.
Constraint programming is qualitatively different from the other programming
paradigms that we have seen, such as declarative, object-oriented, and concurrent
programming. Compared to these paradigms, constraint programming is much
closer to the ideal of declarative programming: to say what we want without saying
how to achieve it.

### Structure

This chapter introduces a quite general approach for tackling CSPs called
propagate-and-search or propagate-and-distribute. The chapter is structured as follows:

- Section 12.1 gives the basic ideas of the propagate-and-search approach by means of an
  example. This introduces the idea of encapsulating constraints inside a kind of
  container called a computation space.

## 12.1 Propagate-and-search

In this section, we introduce the basic ideas underlying the propagate-and-search
approach by means of a simple example. Sections 12.3 and 12.3.2 continue this
presentation by showing how the stateful concurrent model is extended to support
this approach and how to program with the extended model.

### 12.1.1 Basic ideas

The propagate-and-search approach is based on three important ideas:

1. Keep partial information. During the calculation, we might have partial information
   about a solution (such as, “in any solution, X is greater than 100”). We keep as much
   of this information as possible.
2. Use local deduction. Each of the constraints uses the partial information to deduce
   more information. For example, combining the constraint “X is less than Y” and the
   partial information “X is greater than 100,” we can deduce that ”Y is greater than
   101” (assuming Y is an integer).
3. Do controlled search. When no more local deductions can be done, then we have to
   search. The idea is to search as little as possible. We will do just a small search
   step and then we will try to do local deduction again. A search step consists in
   splitting a CSPP into two new problems, (P∧C) and (P∧¬C), where C is a new constraint.
   Since each new problem has an additional constraint, it can do new local deductions.
   To find the solutions of P, it is enough to take the union of the solutions to the two
   new problems. The choice of C is extremely important. A well-chosen C will often lead
   to a solution in just a few search steps.

### 12.1.2 Calculating with partial information

The first part of constraint programming is calculating with partial information,
namely keeping partial information and doing local deduction on it. We give an
example to show how this works, using intervals of integers. Assume that x and y
measure the sides of a rectangular field of agricultural land in integral meters. We
only have approximations toxandy. Assume that 90≤x≤110 and 48≤y≤53.
Now we would like to calculate with this partial information. For example, is
the area of the field bigger than 4000 m^2? This is easy to do with constraint
programming. We first declare what we know about x and y:

```
field(X, Y) :-
  X in 90..110,
  Y in 48..53.
```

```
field(X, Y).
```

The notation `X in 90..110` means X ∈ { 90,91,...,110 }. Now let us calculate with
this information. With constraint programming, `Area #=&lt; 4000` will return with false
immediately:

```
field(X, Y, Area) :-
  X in 90..110,
  Y in 48..53,
  Area #&gt; 0,
  Area #= X*Y.
```

```
field(100, Y, Z), Z in 4000..5000.
```

We can also display the area directly: (Area in 4320..5830).

```
field(_,_,Area).
```

From this we know the area must be in the range from 4320 to 5830 m^2. The
statement `Area #= X*Y` is a constraint that multiplies X and Y and equates the result
with Area. Technically, it is called a propagator: it looks at its arguments
and propagates information between them. In this case, the propagation is simple:
the minimal value of `Area` is updated to 90×48 (which is 4320) and the maximal value
of `Area` is updated to 110×53 (which is 5830). Now let us add some more information about
x and y and see what we can deduce from it. Assume we know that the difference x − 2*y is
exactly 11 m. We know this by fitting a rope to the y side. Passing the rope twice on the
x side leaves 11 m. What can we deduce from this fact? Add the constraint: `X - 2*Y #= 11`to the definition of`field(X,Y,Area)`above. (Or just add it as a further constraint on`X`and`Y`when querying`field/3`.)

```
field(X,Y,Area), X - 2*Y #= 11.
```

This displays `Area in 5136..5341` for area, `X in 107..109` for x and `Y in 48..49` for y.
This is a very simple example of calculating with partial information, but it can already
be quite useful.

### 12.1.3 An example

We now look at an example of a complete constraint program, to see how propagate-
and-search actually works. Consider the following problem:

How can I make a rectangle out of 24 unit squares so that the
perimeter is exactly 20?

Say that x and y are the lengths of the rectangle’s sides. This gives two equations:

```
x·y = 24
2 · (x+y) = 20
```

The second equation can be simplified to `x+y= 10`. We add a third equation:

```
x ≤ y
```

Strictly speaking, the third equation is not necessary, but including it does no harm
(since we can always flip a rectangle over) and it will make the problem’s solution
easier (technically, it reduces the size of the search space). These three equations
are constraints. We will implement them as propagators, since we will use them to
make local deductions.
To solve the problem, it is useful to start with some information about the
variables. We bound the possible values of the variables. This is not absolutely
necessary, but it is almost always possible and it often makes solving the problem
easier. For our example, assume that X and Y each range from 1 to 9. This is
reasonable since they are positive and less than 10. This gives two additional
equations:

```
x∈{ 1 , 2 ,..., 9 }
y∈{ 1 , 2 ,..., 9 }
```

These equation are also constraints. We will implement them as basic constraints,
which can be represented directly in memory. This is possible since they are of the
simple form “variable in an explicit set.”

#### The initial problem

Now let us start solving the problem. We have three propagators and two basic
constraints. This gives the following situation:

```
S 1 : X*Y = 24, X+Y = 10,  X =&lt; Y || 1 ≤ X ≤ 9, 1 ≤ Y ≤ 9
```

which we will call the computation space `S 1`. A computation space contains the
propagators and the basic constraints on the problem variables. We have the three
propagators X\*Y=24,X+Y=10, and X=&lt;Y.

#### Local deductions

Each propagator now tries to do local deductions. For example, the propagator
X*Y = 24 notices that since Y is at most 9, that X cannot be 1 or 2. Therefore X is
at least 3. It follows that Y is at most 8 (since 3*8=24). The same reasoning can
be done with X and Y reversed. The propagator therefore updates the computation
space:

```
S 1 : X*Y = 24, X+Y = 10, X =&lt; Y || 3 ≤ X ≤ 8, 3 ≤ Y ≤ 8
```

Now the propagator X+Y = 10 enters the picture. It notices that since Y cannot be
2, therefore X cannot be 8. Similarly, Y cannot be 8 either. This gives

```
S 1 : X*Y = 24, X+Y = 10, X =&lt; Y || 3 ≤ X ≤ 7, 3 ≤ Y ≤ 7
```

With this new information, the propagator X*Y = 24 can do more deduction. Since
X is at most 7, therefore Y must be at least 4 (because 3*7 is definitely less than
24). If Y is at least 4, then X must be at most 6. This gives

```
S 1 : X*Y = 24, X+Y = 10, X =&lt; Y || 4 ≤ X ≤ 6, 4 ≤ Y ≤ 6
```

At this point, none of the propagators sees any opportunities for adding information.
We say that the computation space has become stable. Local deduction cannot add
any more information.

#### Using search

How do we continue? We have to make a guess. Let us guess X=4. To make sure
that we do not lose any solutions, we need two computation spaces: one in which
X = 4 and another in which X ≠ 4. This gives

```
S 2 : X*Y = 24, X+Y = 10, X =&lt; Y || X = 4, 4 ≤ Y ≤ 6
S 3 : X*Y = 24, X+Y = 10, X =&lt; Y || 5 ≤ X ≤ 6, 4 ≤ Y ≤ 6
```

Each of these computation spaces now has the opportunity to do local deductions
again. For `S 2` , the local deductions give a value of Y:

```
S 2 : X*Y = 24, X+Y = 10, X =&lt; Y || X = 4, Y = 6
```

At this point, each of the three propagators notices that it is completely solved
(it can never add any more information) and therefore removes itself from the
computation space. We say that the propagators are entailed. This gives

```
S 2 : (empty) || X = 4, Y = 6
```

The result is a solved computation space. It contains the solution X = 4, Y = 6.
Let us see what happens with `S 3`. Propagator X\*Y = 24 deduces that X = 6, Y = 4
is the only possibility consistent with itself (we leave the reasoning to the reader).
Then propagator X =&lt; Y sees that there is no possible solution consistent with itself.
This causes the space to fail:

```
S 3 : (failed)
```

A failed space has no solution. We conclude that the only solution is X = 4, Y = 6.

### 12.1.4 Executing the example

Let us run this example. We define the problem by writing a one-argument
procedure whose argument is the solution. Running the procedure sets
up the basic constraints, the propagators, and (not in this Prolog CLP version) selects a distribution strategy (the Oz code in the textbook allows selecting a distribution strategy). The
distribution strategy defines the “guess” that splits the search in two. Here is the
procedure definition:

```
rectangle(X, Y) :-
    X in 1..9, Y in 1..9,
    X*Y #= 24, X+Y #= 10, X #=&lt; Y.
```

```
rectangle(X,Y).
```

To find the solutions, we use the predicate label which
takes a list of variables to enumerate:

```
rectangle(X,Y), label([X,Y]).
```

This displays a list of all solutions, since there is only one.
All the constraint operations used in this example in the textbook, namely ::, =:, =&lt;:, and
FD.distribute, are predefined in the Mozart system. The full constraint program-
ming support of Mozart consists of several dozen operations. All of these operations
are defined in the constraint-based computation model. This model introduces just
two new concepts to the stateful concurrent model: finite domain constraints (ba-
sic constraints like X::1#9 ) and computation spaces. All the richness of constraint
programming in Mozart is provided by this model. The similar FD (finite domain) CLP model of Prolog is further explained here: http://www.swi-prolog.org/man/clpfd.html

### 12.1.5 Summary

The fundamental concept used to implement propagate-and-search is the computation space, which contains propagators and basic constraints. Solving a problem
alternates two phases. A space first does local deductions with the propagators.
When no more local deductions are possible, i.e., the space is stable, then a search
step is done. In this step, two copies of the space are first made. A basic constraint
C is then “guessed” according to a heuristic called the distribution strategy. The
constraint C is then added to the first copy and ¬C is added to the second copy. We
then continue with each copy. The process is continued until all spaces are either
solved or failed. This gives us all solutions to the problem.

The CLP(FD) of Prolog is similar.

# Examples

### Factorial

Finding factorials using CLP and recursion

```
factorial(0, 1).
factorial(Number, Factorial) :-
        Number #&gt; 0,
        NextNumber #= Number - 1,
        Factorial #= Number * NextNumberFactorial,
    	Factorial #\= 0,
        factorial(NextNumber, NextNumberFactorial).
```

```
factorial(N,F).
```

### Pattern matching

Using pattern matching to find sum of values in a list

```
sum(0, []).
sum(Total, [Head|Tail]) :-
    Total #= Head + TailTotal,
    sum(TailTotal, Tail).
```

```
sum(X, [1,2,5,3]).
```

### Simple payment with coins

```
simple_payment(Sum, Ones, Fives, Tens, Twenties) :-
    Ones in 0..11,
    Fives in 0..4,
    Tens in 0..3,
    Twenties in 0..2,
    Sum #= 20*Twenties + 10*Tens + 5*Fives + Ones.
```

```
simple_payment(25, Ones, Fives, Tens, Twenties).
```

Use label to list possible solutions:

```
simple_payment(25, Ones, Fives, Tens, Twenties), label([Ones, Fives, Tens, Twenties]).
```

The predicate works both ways:

```
simple_payment(Total, 5, 4, 1, 2).
```

# Exercise

The "Simple payment with coins" example above uses hardcoded values and amounts available for the coins.
Use what you have learned to create a small prolog predicate that takes a list of coins as input instead.
The predicate should accept a payment sum and a list of coin(AmountOfCoinsNeeded, ValueOfCoin, AmountOfCoinsAvailable) (you can choose variable names yourself).

Fill in the empty code block and validate it by using the queries below.

Hint: pattern matching and recursion are powerful tools in prolog, just like in Oz.

```
payment(0, []).
payment(Sum, [coin(Type,Value,Available)|Tail]) :-
    Type in 0..Available,
    Sum #= Value*Type + TailTotal,
    payment(TailTotal, Tail).
```

You can as usual use label to get possible solutions:

```
payment(25, [coin(Ones,1,11),coin(Fives,5,4),coin(Tens,10,3),coin(Twenties,20,2)]), label([Ones, Fives, Tens, Twenties]).
```

#### Copy your code from the program/code block and deliver it on blackboard when done.
