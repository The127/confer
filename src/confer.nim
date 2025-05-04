type
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