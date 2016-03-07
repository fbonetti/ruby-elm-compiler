require 'elm/compiler/exceptions'
require 'open3'
require 'tempfile'
require 'mkmf'

module Elm
  class Compiler
    def self.compile(*args)
      new(*args).compile
    end

    def initialize(elm_files, output_path: nil, elm_make_path: nil)
      @elm_files = elm_files
      @output_path = output_path
      @elm_make_path = elm_make_path
    end

    attr_reader :elm_files, :output_path, :elm_make_path

    def compile
      fail ExecutableNotFound unless elm_executable_exists?

      if output_path
        to_file
      else
        to_s
      end
    end

    private

    def elm_executable_exists?
      File.exist?(elm_executable)
    end

    def to_s
      Tempfile.open(['elm', '.js']) do |tempfile|
        to_file(tempfile.path)
        return File.read tempfile.path
      end
    end

    def to_file(path = output_path)
      Open3.popen3(elm_executable, *elm_files, '--yes', '--output', path) do |_stdin, _stdout, stderr, wait_thr|
        fail CompileError, stderr.gets(nil) if wait_thr.value.exitstatus != 0
      end
    end

    def elm_executable
      elm_make_path || find_executable0('elm-make')
    end
  end
end
