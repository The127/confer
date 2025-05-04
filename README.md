# Confer

A composable and expandable configuration parser for Nim applications.

⚠️ **WARNING**: This is an experimental library (v0.1.0) and just a toy project to learn nim.

## About

Confer is a flexible configuration parser library for Nim that makes it easy to:
- Read configurations from multiple sources
- Support different file formats
- Handle environment variables
- Define custom merge strategies

## Requirements

- Nim >= 2.4.0
- jsony package

## Installation

using the repo link

## Features

- **File-based Configuration**: Load configurations from files with media type support
- **Environment Variables**: Native support for environment variable parsing
- **JSON Support**: Built-in JSON parsing capabilities
- **Custom Media Types**: Support for different media types per configuration source
- **Flexible Source System**: Easy to implement new configuration sources
- **Error Handling**: Clear error messaging for missing files and parsing issues
- **Merge Strategies**: Customizable configuration merging capabilities
- **Type Safety**: Strong type checking for configuration structures

## Example Usage
(not tested but you should not use this anyway!)
```nim
nim import confer
type Config = object host: string port: int
let config = newConfigBuilder[Config]() .withJsonParser() .withFileSource("config.json", "application/json") .build()
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License

## Author

The127
