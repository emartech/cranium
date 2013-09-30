require 'cranium/dsl'

module Cranium

  autoload :Configuration, 'cranium/configuration'
  autoload :DataImporter, 'cranium/data_importer'
  autoload :TestFramework, 'cranium/test_framework'

  class << self

    def application
      @application ||= Application.new
    end



    def run
      application.run
    end



    def configuration
      @configuration ||= Configuration.new.freeze
    end



    def configure
      mutable_configuration = configuration.dup
      yield mutable_configuration
      @configuration = mutable_configuration
      @configuration.freeze
    end

  end

end
