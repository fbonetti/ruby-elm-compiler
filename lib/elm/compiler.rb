require 'elm/compiler/exceptions'
require 'open3'
require 'tempfile'

module Elm
  class Compiler
    class << self
      def compile(elm_files, output_path: nil, elm_path: nil, debug: false)
        elm_path ||= `which elm`.strip
        fail ExecutableNotFound unless elm_executable_exists?(elm_path)

        if output_path
          elm_make(elm_path, elm_files, output_path, debug)
        else
          compile_to_string(elm_path, elm_files, debug)
        end
      end

      private

      def elm_executable_exists?(elm_path)
        File.exist?(elm_path)
      end

      def compile_to_string(elm_path, elm_files, debug)
        Tempfile.open(['elm', '.js']) do |tempfile|
          elm_make(elm_path, elm_files, tempfile.path, debug)
          return File.read tempfile.path
        end
      end

      def elm_make(elm_path, elm_files, output_path, debug)
        args = [{'LANG' => 'en_US.UTF8'}, elm_path, 'make', *elm_files, '--output', output_path]
        args << '--debug' if debug
        Open3.popen3(*args) do |_stdin, _stdout, stderr, wait_thr|
          fail CompileError, stderr.gets(nil) if wait_thr.value.exitstatus != 0
        end
      end
    end
  end
end
