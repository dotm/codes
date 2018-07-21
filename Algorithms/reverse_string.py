def foldright(reducer, accumulator, sequence):
  for sequence_element in reversed(sequence[:]):
    accumulator = reducer(accumulator, sequence_element)
  return accumulator

def reverse_string(string):
  adder = lambda accumulator, sequence_element: accumulator + sequence_element
  return foldright(adder, '', string)

reverse_string('lola')