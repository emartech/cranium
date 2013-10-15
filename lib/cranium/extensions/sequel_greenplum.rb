require 'sequel'
Sequel.require 'adapters/shared/postgres'

module Sequel::Postgres::DatasetMethods

  def insert_clause_methods
    remove_returning_from INSERT_CLAUSE_METHODS, :insert
  end



  def update_clause_methods
    remove_returning_from UPDATE_CLAUSE_METHODS, :update
  end



  def delete_clause_methods
    remove_returning_from DELETE_CLAUSE_METHODS, :delete
  end



  private

  def remove_returning_from(methods, type)
    methods.reject { |method| method == :"#{type}_returning_sql" }
  end

end
