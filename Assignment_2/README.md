# MDC

### Terminal calculator using RPN, implemented in the the Oz language 

<br/>

### How does the MDC work?

Using the MDC requires basic knowledge of postfix notation and stacks.\
The input to the MDC consists of a string of numbers, operators and commands seperated by spaces.\
The following arguments can be used in the string:
- 'N' *Numbers*
- '+' *addition*
- '-' *subtraction*
- '*' *multiplication*
- '/' *division*
- 'p' *print current stack*
- 'd' *duplicate top of stack*
- 'i' *additive inverse top of stack*
- '^' *multiplicative inverse top of stack*

These arguments are then converted to a list as lexemes before they are analyzed and tokenized
so that they can be futher proccessed.
The tokens are then interpreted as either numbers, operators or commands. Depending on the token it is either added to a stack or performs an operation on the stack. \
Note, as mdc uses postfix notation, the list of tokens can be recursively traversed and operations performed as we go.

- If the token is a number, it is added to the stack.
- If the token is an operation (i.e. +, -, *, /) the operation is performed on the two numbers at the top of the stack.
- If the token is a command (i.e. p, d, i, ^) the command i performed either on the whole stack, or the top element (depending on the command).

When the stack is empty, the stack is returned.

<br/><br/>

### How does the infix notation work?

The method is quite similar to the normal mdc - postfix, but instead of actually performing a certain operation, it pops the values that would be needed to perform that operation from the stack and wraps them in with the operator in using an infix notation (and if needed: a set of parenthesis), then puts the result on the stack.

<br/><br/>

# Theory

1. Formally describe the regular grammar of the lexemes in task 2.

    A formal grammar consists of:

    - A set of terminals, $S$
    - A set of non-terminals, $V$
    - A set of rules, $R$
    - A start symbol, $v_s$,  $v_s \in V$
  
    <br/>

    A grammar $G$ is defined as a tuple, $G = (V, S, R, v_s)$

    ```
    <Lexeme>      := <Number> | <Operation> | <Command>

    <Number>      := {0..9}<Number>.<Number>

    <Operator>    := + | - | / | *

    <Command>     := p | d | ^ | i
    ```

2. Describe the grammar of the infix notation in task 3 using (E)BNF. Beware of operator precedence. \
    Is the grammar ambiguous? \
    Explain why it is or is not ambiguous?

   
    ```
    <Expression>    ::= <number>
                    | <Expression> <Operator> <Expression>
                    | <Command> <Expression>

    <Lexeme>      := <Number> | <Operation> | <Command>

    <Number>      := {0..9}<Number>.<Number>

    <Operator>    := + | - | / | *

    <Command>     := ^ | i
    ```

    Ambiguous because of `<Expression> <Operator> <Expression>`.

3. What is the difference between a context-sensitive and a context-free grammar?
   
    In a context-free grammar you can have the rule `A -> x` and a derivation '`...A...`' which will, by applying the rule, give you '`...x...`'. It does not consider the context surrounding A.

    In a context-sensitive grammar you have to consider the context of symbols.\
    Consider the rule, `aAb -> axb`, here, a,b is the context and can be anything (even empty). x however, will derive from A in the context given by a,b and cannot be empty.

4. You may have gotten float-int errors in task 2. If you haven’t, try running 1+1.0.\
    Why does this happen?\
    Why is this a useful error?

    This happends because Int and Float is not of the same type and Oz is strongly typed and does not convert types automatically. This can be useful for debugging, but the main benefit of not allowing automatic typecasting is that it prevents a potential advasary of misusing the typecasting to manipulate the datatypes to perform operations on datatypes other than what was originally intended by the developers.