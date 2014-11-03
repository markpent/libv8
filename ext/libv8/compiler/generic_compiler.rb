module Libv8
  module Compiler
    class GenericCompiler
      VERSION_REGEXP = /(\d+\.\d+(\.\d+)*)/
      TARGET_REGEXP = /Target: ([a-z0-9\-_.]*)/

      def initialize(path)
        @path = path
      end

      def name
        File.basename @path
      end

      def to_s
        @path
      end

      def version
        call('-v')[0..1].join =~ VERSION_REGEXP
        $1
      end

      def target
        call('-v')[0..1].join =~ TARGET_REGEXP
        $1
      end

      def compatible?
        false
      end

      def call(*arguments)
        if Open3.respond_to? :capture3
          Open3.capture3 arguments.unshift(@path).join(' ')
        else
          [%x[#{@path} #{arguments.join(' ')} 2>&1], '', $?]
        end
      end
    end
  end
end
