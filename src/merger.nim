# merger.nim
proc merger*[T](current, new: T): T =
  result = current
  for name, curVal, newVal in fieldPairs(result, new):
    when curVal is object:
      curVal = merger(curVal, newVal)
    else:
      if newVal != default(typeof(newVal)):
        curVal = newVal