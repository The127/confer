import std/os
import std/strutils

const envMediaType = "application/env"

type
  EnvSource* = object
    prefix: string

proc newEnvSource*(prefix = ""): EnvSource =
  EnvSource(prefix: prefix)

proc getData*(source: EnvSource): RawData =
  var envData = ""

  for key, value in envPairs():
    if source.prefix.len == 0 or key.startsWith(source.prefix):
      let cleanKey = if source.prefix.len > 0: key[source.prefix.len..^1] else: key
      envData.add(cleanKey & "=" & value & "\n")

  RawData(
    data: envData,
    mediaType: envMediaType,
  )