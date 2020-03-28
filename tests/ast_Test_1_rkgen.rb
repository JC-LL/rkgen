module Test_1
  class AstNode
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
