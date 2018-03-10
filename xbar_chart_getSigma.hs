--ghci
{-
let list = [63, 60, 72, 64, 65, 68, 66, 65, 67, 64]
let length = Data.List.genericLength
let mean_average :: [Double] -> Double; mean_average list = (sum list) / (length list)
let standardDeviation_ofSample :: [Double] -> Double; standardDeviation_ofSample list = sqrt ((sumSquare_ofDistance_fromMean) / ((length list) - 1)) where sumSquare_ofDistance_fromMean = sum distance_fromMean_ofEachArrayElement_squared; distance_fromMean_ofEachArrayElement_squared = map (** 2) distance_fromMean_ofEachArrayElement; distance_fromMean_ofEachArrayElement = map (\element -> element - average) list; average = mean_average list; 
let getSigma :: [Double] -> Double -> Double; getSigma list z_value = (mean_average list) + (z_value * (standardDeviation_ofSample list))
-}

--haskell file
import qualified Data.List (genericLength)
count = Data.List.genericLength

mean_average :: [Double] -> Double
mean_average list = (sum list) / (count list)

standardDeviation_ofSample :: [Double] -> Double
standardDeviation_ofSample list = sqrt ((sumSquare_ofDistance_fromMean) / ((count list) - 1))
  where
    sumSquare_ofDistance_fromMean = sum distance_fromMean_ofEachArrayElement_squared
    distance_fromMean_ofEachArrayElement_squared = map (** 2) distance_fromMean_ofEachArrayElement
    distance_fromMean_ofEachArrayElement = map (\element -> element - average) list
    average = mean_average list

getSigma :: [Double] -> Double -> Double
getSigma list z_value = (mean_average list) + (z_value * (standardDeviation_ofSample list))

--usage
--getSigma list (-3)
