import unittest
import std/os
import std/strutils  # Add this import
import confer

suite "EnvSource":
  setup:
    # Save existing env vars we might modify
    let existingFoo = getEnv("FOO", "")
    let existingTestHost = getEnv("TEST_HOST", "")
    let existingTestPort = getEnv("TEST_PORT", "")

    # Set test environment variables
    putEnv("FOO", "bar")
    putEnv("TEST_HOST", "localhost")
    putEnv("TEST_PORT", "8080")

  teardown:
    # Restore environment to previous state
    if existingFoo.len > 0: putEnv("FOO", existingFoo) else: delEnv("FOO")
    if existingTestHost.len > 0: putEnv("TEST_HOST", existingTestHost) else: delEnv("TEST_HOST")
    if existingTestPort.len > 0: putEnv("TEST_PORT", existingTestPort) else: delEnv("TEST_PORT")

  test "EnvSource has correct media type":
    let source = newEnvSource()
    let rawData = source.getData()

    check rawData.mediaType == "application/env"

  test "EnvSource captures all environment variables when no prefix":
    let source = newEnvSource()
    let rawData = source.getData()

    check rawData.data.contains("FOO=bar")
    check rawData.data.contains("TEST_HOST=localhost")
    check rawData.data.contains("TEST_PORT=8080")

  test "EnvSource captures only prefixed variables":
    let source = newEnvSource(prefix = "TEST_")
    let rawData = source.getData()

    check not rawData.data.contains("FOO=bar")
    check rawData.data.contains("HOST=localhost")
    check rawData.data.contains("PORT=8080")

type
  TestConfig = object
    foo*: string
    host: string
    port: string

suite "EnvParser":
  test "Parses environment variables into custom type":
    let parser = newEnvParser[TestConfig]()
    let data = """
FOO=bar
HOST=localhost
PORT=8080
"""
    let result = parser.parse(data.strip())

    check result.host == "localhost"
    check result.foo == "bar"
    check result.port == "8080"

  test "Returns correct media types":
    let parser = newEnvParser[TestConfig]()
    let types = parser.mediaTypes()

    check types == @["application/env"]
