
import GA
import System.Random

type BinPackChromosome = [Int]

type Weights = [Integer]

type NumberOfBins = Int
         

binmakepop :: NumberOfBins -> Weights -> Seed -> Size -> Population BinPackChromosome 
binmakepop n w s size = let listOfChromosomes = binMakeListOfChromosomes n w s size in [((binFitness n w c),c) | c <- listOfChromosomes]

binMakeListOfChromosomes :: NumberOfBins -> Weights -> Seed -> Size -> [BinPackChromosome] 
binMakeListOfChromosomes n w s 0 = []
binMakeListOfChromosomes n w s size = (binMakeRandomChromosome n w (randomNumberLessthanN s 10000)):(binMakeListOfChromosomes n w (randomNumberLessthanN s 10000) (size-1))

binMakeRandomChromosome :: NumberOfBins -> Weights -> Seed -> BinPackChromosome
binMakeRandomChromosome n w s = take (length w) ([floor ((fromIntegral n)* e) | e <- (randomList s)])

binFitness :: NumberOfBins ->Weights -> BinPackChromosome -> FitnessValue
binFitness n w b = let totalWeights = (totalWeightsInBins n w b) in ((maximum totalWeights) - (minimum totalWeights))

totalWeightsInBins :: NumberOfBins -> Weights -> BinPackChromosome -> [Int]
totalWeightsInBins n w b = totalWeightsInBinsHelper 0 n w b

totalWeightsInBinsHelper :: Int -> NumberOfBins -> Weights -> BinPackChromosome -> [Int]
totalWeightsInBinsHelper currentIndex n w b | currentIndex == n = []
                                            | otherwise = (sumOfWeightsInCurrentIndex currentIndex w b):(totalWeightsInBinsHelper (currentIndex+1) n w b)

sumOfWeightsInCurrentIndex :: Int -> Weights -> BinPackChromosome -> Int
sumOfWeightsInCurrentIndex currentIndex w b = fromInteger(sum (zipWith (*) (map (\x -> if x == currentIndex then 1 else 0) b) w))

binCrossOver :: Seed -> BinPackChromosome -> BinPackChromosome -> BinPackChromosome
binCrossOver s parent1 parent2 = let k = randomNumberLessthanN s (length parent1) in ((take k parent1) ++ reverse (take ((length parent1)-k) (reverse parent2)))

binpackga :: NumberOfBins -> Weights -> Seed -> Count -> Population BinPackChromosome -> Evaluated BinPackChromosome
binpackga n w s 0 p =  getChromosomeWithMinFitness p
binpackga n w s c p | fromIntegral (getFitness (getChromosomeWithMinFitness p)) <= 0.05 * fromIntegral (sum w) = getChromosomeWithMinFitness p
                    | otherwise = binpackga n w (randomNumberLessthanN s 1000) (c-1) (binEvolution n w s p)

binEvolution :: NumberOfBins -> Weights -> Seed -> Population BinPackChromosome -> Population BinPackChromosome
binEvolution n w s p =  binEvolutionHelper n w (fromIntegral (length p)) s p

binEvolutionHelper :: NumberOfBins -> Weights -> Count -> Seed -> Population BinPackChromosome -> Population BinPackChromosome
binEvolutionHelper n w 0 s p = [] 
binEvolutionHelper n w c s p = let childChromosome = (binCrossOver s (getChromosome ( p!! (randomNumberLessthanN (randomNumberLessthanN (s+99) 99) (length p)) )) (getChromosome (p!!(randomNumberLessthanN (randomNumberLessthanN s 100) (length p)))) ) in ((binFitness n w childChromosome), childChromosome) : (binEvolutionHelper n w (c-1) (randomNumberLessthanN (s+(fromIntegral c)) 100) p)

binPackGASolve :: NumberOfBins -> Weights -> Seed -> Count -> Size -> Evaluated BinPackChromosome
binPackGASolve n w seed c size = binpackga n w seed c (binmakepop n w seed size)
{--
*BinPacking> binPackGASolve 3 [1,2,3,4,5] 4 20 20
(0,[2,1,1,2,0]) -- Optimal
*BinPacking> binPackGASolve 4 [1,2,3,5,4,5] 1 40 40
(5,[2,2,0,3,1,0])
*BinPacking> binPackGASolve 4 [1,2,3,5,4,5] 1 100 100
(0,[2,0,0,1,2,3]) -- Optimal
*BinPacking> binPackGASolve 5 [1,2,3,5,6,4,5] 1 50 100
(9,[1,1,2,1,0,3,3])
*BinPacking> binPackGASolve 5 [1,2,3,5,6,4,5] 3 50 100
(1,[2,0,0,4,3,2,1]) -- Optimal
*BinPacking> binPackGASolve 5 [1,2,3,5,6,4,5,1,3] 7 600 200
(10,[3,1,0,4,4,1,2,1,1])
*BinPacking> binPackGASolve 5 [1,2,3,5,6,4,5,1,3] 7 800 800
(7,[3,0,4,0,1,4,2,3,1])
*BinPacking> binPackGASolve 5 [1,2,3,5,6,4,5,1,3] 7 800 1000
(0,[2,1,4,0,3,1,2,0,4]) -- Optimal 
--}
