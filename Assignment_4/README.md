# Assignment 4

By: Alexander Høyby\
October 22, 2021

</br>

## Task 3

Q: What are the first three digits of the output? 
A: 100

Q: What is the benefit of running on two separate threads?
A: Increases performance as the CPU can compute multiple things in parallel.

## Task 4

Q: Who does this affect task 3 in terms of throughput and resource usage?
A: Lazy execution, also called call-by-need, makes sure that a statement is executed only when the return value is needed.

- In Task 3, our implementation of `GenerateOdd` is free to use as much resources as it would like, to generate all the whole result
at once, once requeted. This is nice if we know that we always want to use the whole result.

- In Task 4 however, the lazy implementation of `GenerateOdd` makes sure that we only calculate the result we need as far as we need, and nothing extra.
This can be beneficial when the result is potential infinte. Or to increase performance as you're avoiding unecessary calculations.