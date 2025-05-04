# tests/test_json_parser.nim
import unittest
import confer

suite "JsonParser":
  type
    DbConfig = object
      host: string
      port: int
      password: string
    
    Config = object
      name: string
      enabled: bool
      db: DbConfig

  test "Parser should report correct media types":
    let parser = newJsonParser[Config]()
    check:
      parser.mediaTypes() == @["application/json"]

  test "Parse valid JSON":
    let parser = newJsonParser[Config]()
    let json = """
    {
      "name": "test",
      "enabled": true,
      "db": {
        "host": "localhost",
        "port": 5432,
        "password": "secret"
      }
    }
    """
    
    let result = parser.parse(json)
    check:
      result.name == "test"
      result.enabled == true
      result.db.host == "localhost"
      result.db.port == 5432
      result.db.password == "secret"

  test "Parse JSON with missing fields":
    let parser = newJsonParser[Config]()
    let json = """
    {
      "name": "test",
      "db": {
        "host": "localhost"
      }
    }
    """
    
    let result = parser.parse(json)
    check:
      result.name == "test"
      result.enabled == false  # default value
      result.db.host == "localhost"
      result.db.port == 0  # default value
      result.db.password == ""  # default value

  test "Parse invalid JSON":
    let parser = newJsonParser[Config]()
    let invalidJson = "{ invalid json }"
    
    expect ConfigError:
      discard parser.parse(invalidJson)

  test "Parse empty JSON object":
    let parser = newJsonParser[Config]()
    let emptyJson = "{}"
    
    let result = parser.parse(emptyJson)
    check:
      result.name == ""
      result.enabled == false
      result.db.host == ""
      result.db.port == 0
      result.db.password == ""

  test "Parse JSON with extra fields":
    let parser = newJsonParser[Config]