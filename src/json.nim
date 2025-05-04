import jsony

type
  JsonParser*[T] = object

proc newJsonParser*[T](): JsonParser[T] =
  JsonParser[T]()

proc mediaTypes*[T](_: JsonParser[T]): seq[string] =
  @["application/json"]

proc parse*[T](parser: JsonParser[T], data: string): T =
  try:
    result = fromJson(data, T)
  except JsonError as e:
    raise newException(ConfigError, "JSON parsing error: " & e.msg)
  except Exception as e:
    raise newException(ConfigError, "Error parsing JSON: " & e.msg)

proc withJsonParser*[T](self: ConfigBuilder[T]) {.deprecated.} =
  self.withParser(newJsonParser[T]())