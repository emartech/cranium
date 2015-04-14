require 'sequel'
require 'sequel/extensions/connection_validator'

module Cranium::Database

  def self.connection
    @connection ||= setup_connection
  end



  def self.[](name)
    @connections ||= {}
    @connections[name] ||= Sequel.connect @definitions[name].connect_to, loggers: Cranium.configuration.loggers
  end



  def self.register_database(name, &block)
    @definitions ||= Cranium::DefinitionRegistry.new Cranium::DSL::DatabaseDefinition
    @definitions.register_definition name, &block
  end



  private


  def self.setup_connection
    connection = Sequel.connect Cranium.configuration.greenplum_connection_string, loggers: Cranium.configuration.loggers
    connection.extension :connection_validator
    connection.pool.connection_validation_timeout = -1
    return connection
  end

end
