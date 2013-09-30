module Cranium
  module DSL

    # Imports data into the database.
    #
    # The specifics of the load process must be provided inside the block passed to this method.
    #
    # @param [Symbol] name The name of the load process. Used for logging.
    # @param [Proc] block The block that provides customization options for the load process.
    def import(name, &block)
      importer = DataImporter.new(name)
      importer.instance_eval &block
      importer.import
    end

  end
end

self.extend Cranium::DSL
