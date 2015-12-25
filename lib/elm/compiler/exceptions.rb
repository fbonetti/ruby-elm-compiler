module Elm
  class Compiler
    class Error < StandardError; end
    class ExecutableNotFound < Error; end
    class CompileError < Error; end
  end
end
