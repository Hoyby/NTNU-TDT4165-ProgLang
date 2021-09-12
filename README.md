<h1>Lecture notes</h1>


<h3>Lecture 1</h3>


Programs can be:



* compiled, then executed on the target machine (C);
* interpreted directly on the target machine (Python);

Hybrid approaches are also possible.

The are a number of different programming paradigms and concepts available in different languages, e.g.,



* object-oriented programming (OOP),
* declarative programming,
* functional programming,
* programming with lazy execution,
* concurrent programming,
* logic programming, etc.

A program is a sequence of statements. Statements update the state of variables etc.

**Object-oriented programming**



* A program defines a set of objects that are encapsulations of data and operations (methods).
* Models of entities in real world?
* Separation of class and instance.
* Separation of state (attributes/properties) and behaviour (methods/features).
* Objects send messages to (call methods on) each other.
* Objects execute operations when they receive messages.

Simula, Java, C++, C#, Ruby, Smalltalk

**Functional programming**



* A program defines a set of functions.
* Functions, when called with appropriate arguments, compute values based on the input.
* Functions are first-class objects: they can be both arguments to and return values from calls to other functions.
* In pure functional programming there are no side-effects—variables are not mutable variables, there is no I/O.

Haskell, Lisp, Scheme



**Logic programming**



* A program is a set of logical assertions: facts and rules.
* A program may be read as a logical expression or as a set of operations to be executed.
* An execution of a program follows an inference pattern to prove or disprove a query.

Prolog, Datalog (deductive databases), Mercury, OWL, Semantic Web languages


**Syntax vs. Semantics**

Syntax Definition of the form of programs in a language.

Specifies which sequences of symbols are valid (are programs), and which are not.

Semantics Definition of the meaning of programs in a language. Specifies what the computer has to do during an execution of a program.

TODO: Formal language, formal grammar.

TODO: Noam Chomsky defined four classes of languages

BNF Notation



* Grammars are usually written using a special notation: the Backus-Naur Form (BNF).
* BNF is often extended with convenience symbols to shorten the notation: the Extended BNF (EBNF).
* BNF (and EBNF) is a metalanguage, a language for talking about languages.

TODO: Regular language (and state machines), regular grammar, regular expressions.

<h3></h3>



* A lexical analyzer (scanner, lexer, tokenizer) reads the sequence of characters and outputs a sequence of tokens.
* A parser reads a sequence of tokens and outputs a structured (typically non-linear) internal representation of the program—a syntax tree (parse

tree).



* The syntax tree is further processed, e.g., by an interpreter or by a compiler.

How are programs processed?

Program:	 `if X == 1 then . . .`\
Input: 		`‘i’ ‘f’ ‘ ’ ‘X’ ‘ ’ ‘=’ ‘=’ ‘ ’ ‘1’ ‘ ’ ‘t’ ‘h’ ‘e’ ‘n’ ...`\
Lexemization: 	`‘if’ ‘X’ ‘==’ ‘1’ ‘then’ . . .`\
Tokenization: 	`key(‘if’) var(‘X’) op(‘==’) int(1) key(‘then’) ...`\
Parsing: 	`program(ifthenelse(eq(var(‘X’)
int(1))
...
...)
...)`


Interpretation: execution according to language semantics

Compilation: code generation according to language semantics

Example (Partial syntax of Oz)

```
<statement> ::= skip
            | if <variable> then <statement> else <statement> end
            | ...
```
where skip, if, then, else, and end are symbols from the alphabet of lexemes.

TODO: derivation of language.

A grammar is ambiguous if a sentence can be parsed in more than one way.

In practice, most programs have more than one derivation, but all of them correspond to the same parse tree.

TODO: Kernel language
