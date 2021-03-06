# Genetic-Algorithm-Haskell

Genetic Algorithms provide a method of creating approximate solutions to a wide class of intractable problems. This is an implementation of a Genetic Algorithm in Haskell, a the Functional Language, used to solve the Traveling Salesman Problem and the Bin Packing Problem.

  **Traveling Salesman Problem**

The the following variant of the Traveling Salesman problem is considered here: The input is a list of points represented by the x and y co-ordinates represented as tuples. Hence a chromosome for the Traveling Salesman problem is a list of tuples, representing the co-ordinates of the points in 2D space.

The fitness function is nothing but the sum of Euclidian distances between adjacent points in the chromosome. This should also includes the distance between the first and last points in the chromosome, because the chromosome has to be interpreted as a circular list as the Traveling Salesman is returns to the point/city from which he started.

A crossover in the case of the Traveling Salesman problem is performed by creating a new list by choosing either of the parent randomly, with equal probability and taking the first element in the chosen list to add it to our new list. We further eliminate duplicates from the list, to generate a new offspring.

The arguments required for the tspSolver are: the list of points, in any order, a seed to generate random numbers, the number of evolutions to be simulated, and the size of the initial population.

#### Examples

tspGASolve [(2,2),(5,5),(3,3),(1,1),(7,7)] 3 2 2
(20,[(3,3),(5,5),(1,1),(2,2),(7,7)]) -- Not optimal

tspGASolve [(2,2),(5,5),(3,3),(1,1),(7,7)] 3 10 10
(14,[(2,2),(1,1),(5,5),(7,7),(3,3)]) -- Optimal

tspGASolve [(1,2),(6,9),(2,3),(11,15),(3,4),(12,14),(0,0)] 3 10 10
(49,[(11,15),(3,4),(2,3),(1,2),(0,0),(12,14),(6,9)]) -- Not optimal

tspGASolve [(1,2),(6,9),(2,3),(11,15),(3,4),(12,14),(0,0)] 3 20 10
(49,[(11,15),(3,4),(2,3),(1,2),(0,0),(12,14),(6,9)]) -- Not optimal

tspGASolve [(1,2),(6,9),(2,3),(11,15),(3,4),(12,14),(0,0)] 3 100 10
(49,[(11,15),(3,4),(2,3),(1,2),(0,0),(12,14),(6,9)]) -- Not optimal

tspGASolve [(1,2),(6,9),(2,3),(11,15),(3,4),(12,14),(0,0)] 3 200 100
(34,[(1,2),(3,4),(6,9),(11,15),(12,14),(2,3),(0,0)]) -- Optimal

**Bin-packing problem**

The following variant of the bin-packing problem is considered.

Given b bins and w weights, that can each weigh a different amount. The objective is to assign all the weights to bins, to give as equal a distribution as possible. This can be gauged by summing the weight held in each bin, and examining the difference between the heaviest bin and the lightest bin. The smaller this difference, the better.

A chromosome for the Bin-packing problem is represented by a list of integers. Each integer in the list represents which bin the weight belongs to. Hence each element in the list is an integer in the range [0, b).

The fitness function for this problem is calculated by summing the weight held in each bin, and examining the difference between the heaviest bin and the lightest bin.

A crossover is performed by choosing a random number between [0, w) and concatenating the part on the left side of this integer on the first parent and the right side of this integer on the second parent, to generate a new offspring.

The binPackingSolver takes in the following arguments: number of bins, list of weights, a seed to generate random numbers, the number of evolutions to be simulated, and  the size of the initial population.

The output type returned is an Evaluated Chromosome, which is a tuple of the fitnessValue of the chromosome and the chromosome itself.

#### Examples

binPackGASolve 3 [1,2,3,4,5] 4 20 20
(0,[2,1,1,2,0]) -- Optimal

binPackGASolve 4 [1,2,3,5,4,5] 1 40 40
(5,[2,2,0,3,1,0]) -- Not optimal

binPackGASolve 4 [1,2,3,5,4,5] 1 100 100
(0,[2,0,0,1,2,3]) -- Optimal

binPackGASolve 5 [1,2,3,5,6,4,5] 1 50 100
(9,[1,1,2,1,0,3,3]) -- Not optimal

binPackGASolve 5 [1,2,3,5,6,4,5] 3 50 100
(1,[2,0,0,4,3,2,1]) -- Optimal

binPackGASolve 5 [1,2,3,5,6,4,5,1,3] 7 600 200
(10,[3,1,0,4,4,1,2,1,1]) -- Not optimal

binPackGASolve 5 [1,2,3,5,6,4,5,1,3] 7 800 800
(7,[3,0,4,0,1,4,2,3,1]) -- Not optimal

binPackGASolve 5 [1,2,3,5,6,4,5,1,3] 7 800 1000
(0,[2,1,4,0,3,1,2,0,4]) -- Optimal
