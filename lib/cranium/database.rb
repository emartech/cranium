require 'sequel'

module Cranium::Database

  def self.connection
    @connection ||= Sequel.connect Cranium.configuration.greenplum_connection_string, loggers: Cranium.configuration.loggers
  end

end