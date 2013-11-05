require 'cranium/extensions/sequel_greenplum'

module Cranium::Database

  def self.connection
    @connection ||= Sequel.connect Cranium.configuration.greenplum_connection_string, loggers: Cranium.configuration.loggers
  end



  def self.[](name)
    @connections ||= {}
    @connections[name] ||= Sequel.connect Cranium.application.databases[name].connect_to, loggers: Cranium.configuration.loggers
  end

end
