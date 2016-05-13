require 'elm/compiler/exceptions'
require 'open3'
require 'tempfile'
require 'mkmf'

module Elm
  class Compiler
    class << self
      def compile(elm_files, output_path: nil, elm_make_path: nil)
        elm_executable = elm_make_path || find_executable0("elm-make")
        fail ExecutableNotFound unless elm_executable_exists?(elm_executable)

        if output_path
          elm_make(elm_executable, elm_files, output_path)
        else
          compile_to_string(elm_executable, elm_files)
        end
      end

      private

      def elm_executable_exists?(elm_executable)
        File.executable?(elm_executable)
      end

      def compile_to_string(elm_executable, elm_files)
        output = ''

        Tempfile.open(['elm', '.js']) do |tempfile|
          elm_make(elm_executable, elm_files, tempfile.path)
          output = File.read tempfile.path
        end

        output
      end

      def elm_make(elm_executable, elm_files, output_path)
        Open3.popen3({"LANG" => "en_US.UTF8" }, elm_executable, *elm_files, '--yes', '--output', output_path) do |_stdin, _stdout, stderr, wait_thr|
          fail CompileError, stderr.gets(nil) if wait_thr.value.exitstatus != 0
        end
      end
    end
  end
end
