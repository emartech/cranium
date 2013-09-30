require 'cranium/dsl'

module Cranium

  autoload :Application, 'cranium/application'
  autoload :Configuration, 'cranium/configuration'
  autoload :DataImporter, 'cranium/data_importer'
  autoload :Source, 'cranium/source'
  autoload :TestFramework, 'cranium/test_framework'

  class << self

    def application
      @application ||= Application.new
    end



    def run(args)
      application.run args
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
