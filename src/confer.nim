import std/os
import std/strutils
import std/macros

include merger

type
  ConfigError* = object of CatchableError

  RawData* = object
    data*: string
    mediaType*: string

  DataSource* = concept x
    getData(x) is RawData

  ConfigParser*[T] = concept x
    mediaTypes(x) is seq[string]
    parse(x, string) is T

  ConfigBuilder*[T] = ref object
    dataSources: seq[DataSource]
    parsers: seq[ConfigParser[T]]
    merger: proc(current, new: T): T

proc newConfigBuilder*[T](merger: proc(current, new: T): T): ConfigBuilder[T] =
  new result
  result.dataSources = @[]
  result.parsers = @[]
  result.merger = merger

proc withSource*[T](self: ConfigBuilder[T], source: DataSource) =
  self.dataSources.add(source)
  
proc withParser*[T](self: ConfigBuilder[T], parser: ConfigParser[T]) =
  self.parsers.add(parser)

proc findParser[T](self: ConfigBuilder[T], mediaType: string): ConfigParser[T] =
  for parser in self.parsers:
    if mediaType in parser.mediaTypes:
      return parser
  raise newException(ConfigError, "No suitable parser found for media type: " & mediaType)

proc build*[T](self: ConfigBuilder[T]): T =
  if self.dataSources.len == 0:
    raise newException(ConfigError, "No data sources provided")

  for source in self.dataSources:
    let rawData = source.getData(source)
    let parser = self.findParser(rawData.mediaType)
    let config = parser.parse(rawData.data)
    result = self.merger(result, config)

include env
include file

proc withEnvParser*[T](self: ConfigBuilder[T], prefix = "") =
  self.withSource(newEnvSource(prefix = prefix))
  self.withParser(newEnvParser())

include json