require "elm/compiler/version"
require "open3"
require "tempfile"

module Elm
  class Compiler
    def self.compile(pathname)
      output = ""

      Tempfile.open(["elm", ".js"]) do |tempfile|
        Open3.popen3("elm-make", pathname.to_s, "--yes", "--output", tempfile.path) do |_stdin, stdout, stderr, wait_thr|
          if wait_thr.value.exitstatus != 0
            raise stderr.gets
          end
        end

        output = File.read tempfile.path
      end

      output
    end
  end
end
