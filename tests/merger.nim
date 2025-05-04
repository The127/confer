# tests/test_merger.nim
import unittest
import confer

suite "ConfigMerger":
  type 
    DbSettings = object
      host: string
      port: int
      password: string
    
    Settings = object
      name: string
      enabled: bool
      db: DbSettings

  test "Merging nested objects":
    let current = Settings(
      name: "test",
      enabled: true,
      db: DbSettings(
        host: "localhost",
        port: 5432,
        password: "secret"
      )
    )
    
    let new = Settings(
      db: DbSettings(
        port: 6543,  # only changing the port
      )
    )
    
    let result = merger(current, new)
    
    check:
      result.name == "test"
      result.enabled == true
      result.db.host == "localhost"
      result.db.port == 6543
      result.db.password == "secret"

  test "Merging nested objects with default values":
    let current = Settings(
      name: "test",
      db: DbSettings(
        host: "localhost",
        port: 5432
      )
    )
    
    let new = Settings(
      db: DbSettings()  # all defaults
    )
    
    let result = merger(current, new)
    
    check:
      result.name == "test"
      result.db.host == "localhost"
      result.db.port == 5432
