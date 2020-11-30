
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