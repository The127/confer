# tests/test_merger.nim
import unittest
import confer

suite "ConfigMerger":
  type
    TestConfig = object
      name: string
      value: string
      count: int
      enabled: bool

  test "Basic merging with string fields":
    let current = TestConfig(name: "original", value: "first")
    let new = TestConfig(value: "second")
    let result = merger(current, new)

    check:
      result.name == "original"  # unchanged
      result.value == "second"   # updated

  test "Merging with different field types":
    let current = TestConfig(name: "test", count: 1, enabled: false)
    let new = TestConfig(count: 42, enabled: true)
    let result = merger(current, new)

    check:
      result.name == "test"    # unchanged
      result.count == 42       # updated
      result.enabled == true   # updated

  test "Merging with default values":
    let current = TestConfig(name: "test", value: "hello", count: 100)
    let new = TestConfig()  # all default values
    let result = merger(current, new)

    check:
      result.name == "test"    # unchanged
      result.value == "hello"  # unchanged
      result.count == 100      # unchanged