module JazzModel
  class Base < ActiveRecord::Base
    self.abstract_class = true

    # A named, shared-cache in-memory database so every connection in the pool
    # sees the same data. idle_timeout: 0 keeps the pool from closing idle
    # connections, which would otherwise discard the in-memory database.
    establish_connection(
      adapter: "sqlite3",
      database: "file:jazz_model?mode=memory&cache=shared",
      idle_timeout: 0
    )
    load File.expand_path("../../db/schema.rb", __dir__)

    def self.load_definitions(definition_name = :default)
      definition = JazzModel::Definition[definition_name]
      raise ArgumentError, "Definition #{definition_name} not found." unless definition

      definition.load
    end
  end
end
