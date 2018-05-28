exponentiate :: (Int a) => a -> a -> a
exponentiate base 0 = 1
exponentiate base exponent
  | (exponent even) = exponentiate (base * base) (exponent/2)
  | (exponent odd) = base * (exponentiate (base * base) ((exponent-1)/2))