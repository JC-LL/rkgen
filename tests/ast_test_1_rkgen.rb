module Test_1
  class AstNode
    def accept(visitor, arg=nil)
       name = self.class.name.split(/::/).last
       visitor.send("visit#{name}".to_sym, self ,arg) # Metaprograming !
    end

    def str
      ppr=PrettyPrinter.new
      self.accept(ppr)
    end
  end
   
  class Root < AstNode
    attr_accessor :elements
    def initialize elements=[]
      @elements=elements
    end
  end
   
  class Entity < AstNode
    attr_accessor :generics,:ports
    def initialize generics=[],ports=[]
      @generics,@ports=generics,ports
    end
  end
end # Test_1
