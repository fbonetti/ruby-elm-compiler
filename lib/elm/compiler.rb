require 'elm/compiler/exceptions'
require 'open3'
require 'tempfile'

module Elm
  class Compiler
    class << self
      attr_writer :elm_path
      def elm_path
        @elm_path ||= elm_from_env_path || our_elm_path
      end

      attr_accessor :esm

      def compile(elm_files, output_path: nil, elm_path: self.elm_path, debug: false, esm: self.esm)
        fail ExecutableNotFound unless elm_executable_exists?(elm_path)
        if output_path
          elm_make(elm_path, elm_files, output_path, debug, esm)
        else
          compile_to_string(elm_path, elm_files, debug, esm)
        end
      end

      private

      def compile_to_string(elm_path, elm_files, debug, esm)
        Tempfile.open(['elm', '.js']) do |tempfile|
          elm_make(elm_path, elm_files, tempfile.path, debug, esm)
          return File.read tempfile.path
        end
      end

      def elm_make(elm_path, elm_files, output_path, debug, esm)
        args = [
          {"LANG" => "en_US.UTF8" },
          elm_path,
          "make",
          *elm_files,
          "--output=#{output_path}",
          debug ? "--debug" : "--optimize",
        ]
        Open3.popen3(*args) do |_stdin, _stdout, stderr, wait_thr|
          fail CompileError, stderr.gets(nil) if wait_thr.value.exitstatus != 0
        end
        convert_file_to_esm!(output_path) if esm
      end

      def convert_file_to_esm!(path)
        contents = File.read(path)
        exports = contents[/^\s*_Platform_export\((.*)\)\;\n?\}\(this\)\)\;/m, 1]
        contents.gsub!(/\(function\s*\(scope\)\s*\{$/m, '// -- \1')
        contents.gsub!(/['"]use strict['"];$/, '// -- \1')
        contents.gsub!(/^\s*_Platform_export\((.*)\)\;\n?\}\(this\)\)\;/m, '/*\n\1\n*/')
        contents << "\nexport default #{exports};"
        File.write(path, contents)
      end

      def elm_executable_exists?(path)
        `#{path} --version`.strip == "0.19.1"
      rescue
        false
      end

      def elm_from_env_path
        `which elm`.chomp.tap { |p| return nil if p == "" }
      end

      def our_elm_path
        path = "/tmp/elm-0.19.1"
        unless elm_executable_exists?(path)
          system """
            curl -sfLo #{path}.gz https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz
            gunzip -f #{path}.gz
            chmod +x #{path}
          """
        end
        path
      end
    end
  end
end
