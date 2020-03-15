require 'sequel'
require 'sequel/extensions/connection_validator'
Sequel::Deprecation.output = false
Sequel.split_symbols = true

module Cranium::Database

  def self.connection
    @connection ||= setup_connection(Cranium.configuration.greenplum_connection_string)
  end



  def self.[](name)
    @connections ||= {}
    @connections[name] ||= setup_connection(@definitions[name].connect_to,
                                            @definitions[name].retry_count,
                                            @definitions[name].retry_delay)
  end



  def self.register_database(name, &block)
    @definitions ||= Cranium::DefinitionRegistry.new Cranium::DSL::DatabaseDefinition
    @definitions.register_definition name, &block
  end



  private


  def self.setup_connection(connection_details, retry_count = 0, retry_delay = 0)
    (retry_count + 1).times do |try_count|
      connection = if Cranium.configuration.log_queries
                     Sequel.connect(connection_details, loggers: Cranium.configuration.loggers)
                   else
                     Sequel.connect(connection_details)
                   end
      connection.extension :connection_validator
      connection.pool.connection_validation_timeout = -1
      break connection
    rescue Sequel::DatabaseConnectionError
      (try_count == retry_count) ? raise : sleep(retry_delay)
    end
  end

end
