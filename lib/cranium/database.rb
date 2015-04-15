require 'sequel'
require 'sequel/extensions/connection_validator'

module Cranium::Database

  def self.connection
    @connection ||= setup_connection(Cranium.configuration.greenplum_connection_string)
  end



  def self.[](name)
    @connections ||= {}
    @connections[name] ||= setup_connection(@definitions[name].connect_to)
  end



  def self.register_database(name, &block)
    @definitions ||= Cranium::DefinitionRegistry.new Cranium::DSL::DatabaseDefinition
    @definitions.register_definition name, &block
  end



  private


  def self.setup_connection(connection_string)
    connection = Sequel.connect connection_string, loggers: Cranium.configuration.loggers
    connection.extension :connection_validator
    connection.pool.connection_validation_timeout = -1
    return connection
  end

end
