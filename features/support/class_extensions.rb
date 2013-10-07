module Cucumber::Ast

  module MultilineArgument
    class << self

      alias_method :from_old, :from



      def from(argument)
        original_result = from_old(argument)
        if original_result.is_a? Cucumber::Ast::Table
          Cranium::TestFramework::CucumberTable.from_ast_table(original_result).with_patterns(
            "NULL" => nil
          )
        else
          original_result
        end
      end

    end
  end

end