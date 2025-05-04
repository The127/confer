# tests/test_file.nim
import unittest
import confer
import std/os

suite "FileSource":
  setup:
    const testContent = "test content"
    writeFile("test.txt", testContent)

  teardown:
    removeFile("test.txt")

  test "FileSource reads file with specified media type":
    let source = newFileSource("test.txt", "text/plain")
    let data = source.getData()
    
    check:
      data.data == "test content"
      data.mediaType == "text/plain"

  test "FileSource throws on missing file":
    let source = newFileSource("nonexistent.txt", "text/plain")
    
    expect ConfigError:
      discard source.getData()

  test "Different media types for same file":
    let source1 = newFileSource("test.txt", "application/json")
    let source2 = newFileSource("test.txt", "application/yaml")
    
    let data1 = source1.getData()
    let data2 = source2.getData()
    
    check:
      data1.data == data2.data           # Same content
      data1.mediaType == "application/json"
      data2.mediaType == "application/yaml"