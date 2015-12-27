# elm-compiler

[![Build Status](https://travis-ci.org/fbonetti/ruby-elm-compiler.svg?branch=master)](https://travis-ci.org/fbonetti/ruby-elm-compiler)

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

> NOTE: Make sure [Elm](http://elm-lang.org/install) is installed. If the `elm-make` executable can't be found in the current `PATH`, the exception `Elm::Compiler::ExecutableNotFound` will be thrown.

```ruby
Elm::Compiler.compile(elm_files, output_path = nil)
```

* `elm_files`: Accepts a single file path or an array of file paths.
* `output_path`: Path to the output file. If left blank, the compiled Javascript will be returned as a string.



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
Elm::Compiler.compile("Clock.elm", "elm.js")
```

Compile multiple files to file:

```ruby
Elm::Compiler.compile(["Clock.elm", "Counter.elm"], "elm.js")
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fbonetti/elm-compiler.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
