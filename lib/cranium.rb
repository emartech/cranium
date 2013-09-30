require 'cranium/dsl'

module Cranium

  autoload :DataImporter, 'cranium/data_importer'
  autoload :TestFramework, 'cranium/test_framework'

  class << self

    def application
      @application ||= Application.new
    end



    def run
      application.run
    end

  end

end
