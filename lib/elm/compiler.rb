require 'elm/compiler/exceptions'
require 'open3'
require 'tempfile'

module Elm
  class Compiler
    class << self
      def compile(elm_files, output_path: nil, elm_make_path: "elm-make")
        fail ExecutableNotFound unless elm_executable_exists?(elm_make_path)

        if output_path
          elm_make(elm_make_path, elm_files, output_path)
        else
          compile_to_string(elm_make_path, elm_files)
        end
      end

      private

      def elm_executable_exists?(elm_make_path)
        Open3.popen2(elm_make_path){}.nil?
      rescue Errno::ENOENT, Errno::EACCES
        false
      end

      def compile_to_string(elm_make_path, elm_files)
        Tempfile.open(['elm', '.js']) do |tempfile|
          elm_make(elm_make_path, elm_files, tempfile.path)
          return File.read tempfile.path
        end
      end

      def elm_make(elm_make_path, elm_files, output_path)
        Open3.popen3({"LANG" => "en_US.UTF8" }, elm_make_path, *elm_files, '--yes', '--output', output_path) do |_stdin, _stdout, stderr, wait_thr|
          fail CompileError, stderr.gets(nil) if wait_thr.value.exitstatus != 0
        end
      end
    end
  end
end
