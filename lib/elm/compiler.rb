require 'elm/compiler/exceptions'
require 'open3'
require 'tempfile'

module Elm
  class Compiler
    class << self
      def compile(elm_files, output_path = nil)
        if output_path
          elm_make(elm_files, output_path)
        else
          compile_to_string(elm_files)
        end
      end

      private

      def compile_to_string(elm_files)
        output = ''

        Tempfile.open(['elm', '.js']) do |tempfile|
          elm_make(elm_files, tempfile.path)
          output = File.read tempfile.path
        end

        output
      end

      def elm_make(elm_files, output_path)
        Open3.popen3('elm-make', *elm_files, '--yes', '--output', output_path) do |_stdin, _stdout, stderr, wait_thr|
          fail CompileError.new(stderr.gets) if wait_thr.value.exitstatus != 0
        end
      end
    end
  end
end
