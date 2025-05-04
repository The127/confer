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

type
  EnvParser*[T] = object

proc mediaTypes*[T](parser: EnvParser[T]): seq[string] =
  @[envMediaType]

macro assignField(obj: typed, fieldName: string, value: string) =
  # Creates assignment: obj.fieldName = value
  let field = newDotExpr(obj, newIdentNode(fieldName.strVal))
  result = newAssignment(field, value)

proc parse*[T](parser: EnvParser[T], data: string): T =
  result = T()
  for line in data.splitLines():
    if line.len == 0: continue

    let parts = line.split('=', maxsplit=1)
    if parts.len != 2: continue

    let key = parts[0].toLowerAscii()
    let value = parts[1]

    for name, _ in result.fieldPairs:
      if name == key:
        assignField(result, name, value)

proc newEnvParser*[T](): EnvParser[T] =
  EnvParser[T]()

