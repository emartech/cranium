require 'sequel'

module Cranium::Database

  def self.connection
    @connection ||= Sequel.connect Cranium.configuration.greenplum_connection_string, loggers: Cranium.configuration.loggers
  end



  def self.[](name)
    @connections ||= {}
    @connections[name] ||= Sequel.connect @definitions[name].connect_to, loggers: Cranium.configuration.loggers
  end



  def self.register_database(name, &block)
    @definitions ||= Cranium::DefinitionRegistry.new Cranium::DSL::DatabaseDefinition
    @definitions.register_definition name, &block
  end

end
