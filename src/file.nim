# file.nim
type
  FileSource* = object
    path*: string
    targetMediaType*: string

proc newFileSource*(path: string, targetMediaType: string): FileSource =
  FileSource(
    path: path,
    targetMediaType: targetMediaType
  )

proc getData*(source: FileSource): RawData =
  if not fileExists(source.path):
    raise newException(ConfigError, "File not found: " & source.path)
    
  RawData(
    data: readFile(source.path),
    mediaType: source.targetMediaType
  )

proc withFileSource*[T](self: ConfigBuilder[T], path: string, targetMediaType: string) =
  self.withSource(newFileSource(path, targetMediaType))