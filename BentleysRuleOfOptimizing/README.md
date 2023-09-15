# [Bentley's Law of Optimization](https://www.youtube.com/watch?v=H-1-X9bkop8&list=PLUl4u3cNGP63VIBQVWguXxZZi0566y7Wf&index=2)

- Reducing the works of your program
# Data structure
## Packing and Encoding of data
- This reduces the number of things that you need to move from the memory. Thus encoding and packing greatly reduces the total bits needed to store this data.

- Packing the data together using struct, this stores 22 bits but much more easy to access this data.

```C
    typedef struct{
        int year: 13;
        int month: 4;
        int day: 5;
    }date_t;
```

- However, sometimes unpacking the data also reaches to optimization.

## Data structure Augmentation
- Add information to data structure to make common operation to do less work.

- Like augmenting the last pointer to the last element of the list, for quick access of the last element of the list.

# Precomputation
- Perform calculation at mission critical times, you can do metaprogramming to first compute the result of a LUT and store it in your program. The result would be accessed during the run time of the program.

## Caching
- Store the past computed result in cache so that you do not have to compute the result again.
Given a function, with input N, if the func(N) is called again, simply retrieve the result from the stored cache.


## Sparsity
### Compressed Sparse Row(CSR)
- Since matrix usually has zeroes in it, computing 0 in matrix is a waste of time, thus we would like to store only the valid elements using a new form called CSR. Which leads to less space and computation time using the CSR multiplication. SPOTTING ZEROES
### Static Sparse Graph
- Represent the graph using Offsets and Edges.

## Algebraic Identities
- Like replacing the sqrt equalities by squaring it, since multiplication is cheaper than sqrt.

## Short-Circuiting
- Return the result earlier if you know that you have already get the result of your function.

## Ordering tests
- Perform those operations which are more often successful, particular alternative is selected by the test. In expensive task should precede the expensive operation.

## Creating a fast path
- Find other condition which immediatly tell that the function has already done its work. Or the function already evaluates to true or false.

## Combining tests
- Combining tests replace a sequence of tests with one test or switch.

## Hoisting
- Avoid recomputing loop-invariant code each time through, extract the needed computation of your function out.

## Sentinels
- Special dummy values placed in adata structure to simplify the logic of boundary conditions.


## Loop unrolling
- Attempts to save work by combining several consecutive iterations of loop into a single loop

- Full loop unrolling or partial loop unrolling, unrolling the loop with an unrolling factor.


## Loop fusion(Jamming)
- Combining multiple loops.


## Elminates Wasted iteration
- Only perform operation on needed data, rewrite the upper bound of loop bound so that wasted loop is eliminated.