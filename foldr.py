def foldright(reducer, accumulator, sequence):
  for sequence_element in reversed(sequence[:]):
    accumulator = reducer(accumulator, sequence_element)
  return accumulator