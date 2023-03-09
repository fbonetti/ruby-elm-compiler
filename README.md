# elm-compiler

[![Build Status](https://github.com/fbonetti/ruby-elm-compiler/actions/workflows/ci.yml/badge.svg)](https://github.com/fbonetti/ruby-elm-compiler/actions/workflows/ci.yml)

Ruby wrapper for the [Elm language compiler](https://github.com/elm-lang/elm-compiler).

The project is heavily inspired by the [sprockets-elm](https://github.com/NoRedInk/sprockets-elm/blob/0752748904edee0c25f2dd49cc39186c2ef61b08/lib/elm_compiler.rb) repository, written by [rtfeldman](https://github.com/rtfeldman).

## Installation

Install the Elm platform:

http://elm-lang.org/install

Add this line to your application's Gemfile:

```ruby
gem 'elm-compiler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install elm-compiler

## Usage

> NOTE: Make sure [Elm](http://elm-lang.org/install) is installed. If the `elm` executable can't be found in the current `PATH` or via the `elm_path` option, the exception `Elm::Compiler::ExecutableNotFound` will be thrown.

```ruby
Elm::Compiler.compile(elm_files, output_path: nil, elm_path: nil, debug: false, esm: false)
```

* `elm_files`: Accepts a single file path or an array of file paths.
* `output_path`: Path to the output file. If left blank, the compiled Javascript will be returned as a string.
* `elm_path`: Path to the `elm` executable. If left blank, the executable will be looked up in the current `PATH`, if that cannot be found, it will download elm to /tmp/elm-0.19.1 and use that.
* `debug`: Whether or not to compile in debug mode. Default is false.
* `esm`: Whether or not to rewrite the compilation result into ESM format. Default is false. Can also be set on a global basis by `Elm::Compiler.elm = true`


## Examples

Compile to string of Javascript:

```ruby
Elm::Compiler.compile("Clock.elm")
```

Compile multiple files to a string of Javascript:

```ruby
Elm::Compiler.compile(["Clock.elm", "Counter.elm"])
```

Compile to file:

```ruby
Elm::Compiler.compile("Clock.elm", output_path: "elm.js")
```

Compile multiple files to file:

```ruby
Elm::Compiler.compile(["Clock.elm", "Counter.elm"], output_path: "elm.js")
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fbonetti/elm-compiler.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
