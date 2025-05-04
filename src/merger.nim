# merger.nim
proc merger*[T](current, new: T): T =
  result = current
  for name, curVal, newVal in fieldPairs(result, new):
    if newVal != default(typeof(newVal)):
      copyMem(addr curVal, addr newVal, curVal.sizeof)we should change it to support nested