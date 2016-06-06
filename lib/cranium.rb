module Cranium

  autoload :Application, 'cranium/application'
  autoload :Archiver, 'cranium/archiver'
  autoload :AttributeDSL, 'cranium/attribute_dsl'
  autoload :CommandLineOptions, 'cranium/command_line_options'
  autoload :Configuration, 'cranium/configuration'
  autoload :Database, 'cranium/database'
  autoload :DataImporter, 'cranium/data_importer'
  autoload :DataReader, 'cranium/data_reader'
  autoload :DataTransformer, 'cranium/data_transformer'
  autoload :DefinitionRegistry, 'cranium/definition_registry'
  autoload :DimensionManager, 'cranium/dimension_manager'
  autoload :DSL, 'cranium/dsl'
  autoload :ExternalTable, 'cranium/external_table'
  autoload :Extract, 'cranium/extract'
  autoload :FileUtils, 'cranium/file_utils'
  autoload :ImportStrategy, 'cranium/import_strategy'
  autoload :Logging, 'cranium/logging'
  autoload :ProgressOutput, 'cranium/progress_output'
  autoload :Sequel, 'cranium/sequel'
  autoload :SourceRegistry, 'cranium/source_registry'
  autoload :TestFramework, 'cranium/test_framework'
  autoload :TransformationRecord, 'cranium/transformation_record'
  autoload :Transformation, 'cranium/transformation'

  class << self

    def application(argv = [])
      @application ||= Application.new(argv)
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



    def load_arguments
      application.load_arguments
    end

  end

end

self.extend Cranium::DSL
