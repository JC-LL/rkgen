require 'yaml'
require_relative 'code'

module RKGEN
  class Compiler
    attr_accessor :options
    def initialize options={}
      @options=options
    end

    def compile filename
      puts "=> compiling #{filename}"
      @module_name=File.basename(filename,'.rkg').capitalize
      puts "=> module name is #{@module_name}"
      @spec = YAML.load_file(filename)
      #puts @spec.inspect
      generate
    end

    def generate
      puts "=> generating code..."
      code=Code.new
      code << "module #{@module_name}"
      code.indent=2
      code << generate_classes
      code.indent=0
      code << "end # #{@module_name}"
      puts code.finalize
      filename="ast_#{@module_name.downcase}_rkgen.rb"
      code.save_as filename,verbose=true
    end

    def generate_classes
      code=Code.new
      code << "class AstNode"
      code.indent=2
      code << %{def accept(visitor, arg=nil)
       name = self.class.name.split(/::/).last
       visitor.send("visit\#{name}".to_sym, self ,arg) # Metaprograming !
    end

    def str
      ppr=PrettyPrinter.new
      self.accept(ppr)
    end}
      code.indent=0
      code << "end"
      @spec.each do |klass_h|
        klass_name,attributes=klass_h.first
        code.newline
        code << "class #{klass_name.capitalize} < AstNode"
        code.indent=2
        attr_decls=attributes.map{|a| ad=a.downcase ; ":#{ad}"}.join(',')
        code << "attr_accessor #{attr_decls}"
        params=attributes.map{|a|
          ad=a.downcase
          if a.end_with?('S') #big S
            "#{ad}=[]"
          else
            "#{ad}=nil"
          end
        }.join(',')
        code << "def initialize #{params}"
        code.indent=4
        init_lhs=attributes.map{|a| ad=a.downcase ; "@#{ad}"}.join(',')
        init_rhs=attributes.map{|a| ad=a.downcase}.join(',')
        code << "#{init_lhs}=#{init_rhs}"
        code.indent=2
        code << "end"
        code.indent=0
        code << "end"
      end
      code
    end

  end
end