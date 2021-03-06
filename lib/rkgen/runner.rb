require "optparse"

require_relative "compiler"

module RKGEN

  class Runner

    def self.run *arguments
      new.run(arguments)
    end

    def run arguments
      compiler=Compiler.new
      compiler.options = args = parse_options(arguments)
      if args[:parse_only]
        filename=args[:vhdl_file]
        compiler.parse_2 filename
      elsif filename=args[:rkg_file]
        compiler.compile filename
      else
        puts "need a RKGEN file : rkgen [options] <file.rkg>"
      end
    end

    def header
      puts "RKGEN utility (#{VERSION})- (c) JC Le Lann 20"
    end

    private
    def parse_options(arguments)
      header

      parser = OptionParser.new

      no_arguments=arguments.empty?

      options = {}

      parser.on("-h", "--help", "Show help message") do
        puts parser
        exit(true)
      end

      parser.on("-p", "--parse", "parse only") do
        options[:parse_only]=true
      end

      parser.on("--pp", "pretty print back source code ") do
        options[:pp] = true
      end

      parser.on("--ast", "abstract syntax tree (AST)") do
        options[:ast] = true
      end


      parser.on("--vv", "verbose") do
        options[:verbose] = true
      end

      parser.on("-v", "--version", "Show version number") do
        puts VERSION
        exit(true)
      end

      parser.parse!(arguments)

      options[:rkg_file]=arguments.shift #the remaining c file

      if no_arguments
        puts parser
      end

      options
    end
  end
end
