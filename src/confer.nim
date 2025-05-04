type
  ConfigError* = object of CatchableError

  RawData* = object
    data: string
    mediaType: string

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
