import GA
import Data.List
import System.Random

type Coordinate = (Int, Int)

type TSPChromosome = [Coordinate]

tspMakePop :: Seed -> Size -> TSPChromosome -> Population TSPChromosome
tspMakePop s size c = let listOfChromosomes = tspMakeListOfChromosomes s size c in [((tspFitness c),c) | c <- listOfChromosomes]

tspMakeListOfChromosomes :: Seed -> Size -> TSPChromosome -> [TSPChromosome]
tspMakeListOfChromosomes s size l = let perms = perm l in [perms!!i | i <- [(randomNumberLessthanN s (length perms))| s <- (take (fromInteger size) [1..])] ]

perm :: [a] -> [[a]]
perm []      = [[]]
perm [a]     = [[a]]
perm (x:xs)  = insertBetweenListOfLists x (perm xs) 

insertBetweenListOfLists :: a -> [[a]] -> [[a]]
insertBetweenListOfLists a []     = []
insertBetweenListOfLists a (x:xs) = (insertBetweenListHelper a [] x) ++ (insertBetweenListOfLists a xs)

insertBetweenListHelper ::  a -> [a] -> [a] -> [[a]]
insertBetweenListHelper a [] []         = [[a]]
insertBetweenListHelper a [] (x:xs)     = (a:(x:xs)) : (insertBetweenListHelper a [x] xs)
insertBetweenListHelper a (x:xs) (y:ys) = ((x:xs) ++ [a] ++ (y:ys)) : (insertBetweenListHelper a ((x:xs) ++ [y]) ys)
insertBetweenListHelper a (x:xs) []     =  [((x:xs) ++ [a])]

tspFitness :: TSPChromosome -> FitnessValue
tspFitness c =   ( tspFitnessHelper c ) + (euclidianDistance (head c) (head (reverse c))) -- adding distance between first and last nodes

tspFitnessHelper :: TSPChromosome -> FitnessValue
tspFitnessHelper [] = 0
tspFitnessHelper (x:[]) = 0
tspFitnessHelper (x:xs) = (euclidianDistance x (head xs)) + tspFitnessHelper (xs)

euclidianDistance :: Coordinate -> Coordinate -> Int 
euclidianDistance  (x1,y1) (x2,y2) =  floor (sqrt (fromIntegral ((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))))

tspCrossOver :: Seed -> TSPChromosome -> TSPChromosome -> TSPChromosome
tspCrossOver s parent1 parent2 = nub (mixChromosomes s parent1 parent2)

mixChromosomes :: Seed -> TSPChromosome -> TSPChromosome -> TSPChromosome
mixChromosomes s [] [] = [] 
mixChromosomes s [] p2 = p2 
mixChromosomes s p1 [] = p1 
mixChromosomes s p1 p2 | even (randomNumberLessthanN s 1000) = (head p1) : mixChromosomes (randomNumberLessthanN s 99) (tail p1) p2
                        | otherwise = (head p2) : mixChromosomes (randomNumberLessthanN s 199) p1 (tail p2)

tspGASolve :: TSPChromosome -> Seed -> Count -> Size -> Evaluated TSPChromosome
tspGASolve ci seed count size = tspGA seed count (tspMakePop seed size ci)
{--
*TravellingSalesman> tspGASolve [(2,2),(5,5),(3,3),(1,1),(7,7)] 3 2 2
(20,[(3,3),(5,5),(1,1),(2,2),(7,7)])
*TravellingSalesman> tspGASolve [(2,2),(5,5),(3,3),(1,1),(7,7)] 3 10 10
(14,[(2,2),(1,1),(5,5),(7,7),(3,3)]) -- Optimal
*TravellingSalesman> tspGASolve [(1,2),(6,9),(2,3),(11,15),(3,4),(12,14),(0,0)] 3 10  10
(49,[(11,15),(3,4),(2,3),(1,2),(0,0),(12,14),(6,9)])
*TravellingSalesman> tspGASolve [(1,2),(6,9),(2,3),(11,15),(3,4),(12,14),(0,0)] 3 20  10
(49,[(11,15),(3,4),(2,3),(1,2),(0,0),(12,14),(6,9)])
*TravellingSalesman> tspGASolve [(1,2),(6,9),(2,3),(11,15),(3,4),(12,14),(0,0)] 3 100  10
(49,[(11,15),(3,4),(2,3),(1,2),(0,0),(12,14),(6,9)])
*TravellingSalesman> tspGASolve [(1,2),(6,9),(2,3),(11,15),(3,4),(12,14),(0,0)] 3 200  100
(34,[(1,2),(3,4),(6,9),(11,15),(12,14),(2,3),(0,0)]) -- Optimal
--}

tspGA :: Seed -> Count -> Population TSPChromosome -> Evaluated TSPChromosome
tspGA s c p = tspGAHelper s c (100000, []) p

tspGAHelper :: Seed -> Count -> Evaluated TSPChromosome -> Population TSPChromosome -> Evaluated TSPChromosome
tspGAHelper s 0 currentBest p = compareChromosomes currentBest (getChromosomeWithMinFitness p)  
tspGAHelper s c currentBest p = let nextGeneration = (tspEvolution s p) in tspGAHelper (randomNumberLessthanN s 1000) (c-1) (compareChromosomes currentBest (getChromosomeWithMinFitness nextGeneration)) nextGeneration

tspEvolution :: Seed -> Population TSPChromosome -> Population TSPChromosome
tspEvolution s p =  tspEvolutionHelper (fromIntegral (length p)) s p

tspEvolutionHelper :: Count -> Seed -> Population TSPChromosome -> Population TSPChromosome
tspEvolutionHelper 0 s p = [] 
tspEvolutionHelper c s p = let childChromosome = (tspCrossOver s (getChromosome ( p!! (randomNumberLessthanN (randomNumberLessthanN (s+99) 99) (length p)) )) (getChromosome (p!!(randomNumberLessthanN (randomNumberLessthanN s 100) (length p)))) ) in ((tspFitness childChromosome), childChromosome) : (tspEvolutionHelper (c-1) (randomNumberLessthanN (s+(fromIntegral c)) 100) p)

