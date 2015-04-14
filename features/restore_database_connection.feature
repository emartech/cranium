Feature: Sequel database connections are fault tolerant

  Scenario:
    Given a database table called "dim_product" with the following fields:
      | field_name | field_type |
      | item       | TEXT       |
      | title      | TEXT       |
    And a "products.csv" data file containing:
    """
    id,name,category
    JNI-123,Just a product name,Main category > Subcategory > Sub-subcategory > Ultra-subcategory
    CDI-234,Another product name,Smart Insight > Cool stuff | 3dim > 2dim > 1dim
    """
    And the following definition:
    """
    require 'sequel'

    def terminate_connections
      connection = Sequel.connect "postgres://database_administrator:emarsys@192.168.56.43:5432/cranium", loggers: Cranium.configuration.loggers
      connection.run("SELECT pg_terminate_backend(procpid) FROM pg_stat_activity WHERE procpid <> pg_backend_pid() AND datname = 'cranium'")
    end



    source :products do
      encoding "UTF-8"
      delimiter ','

      field :id, String
      field :name, String
    end



    source :transformed_products do
      field :id, String
      field :name, String
    end



    transform :products => :transformed_products do |record|
      output record
    end



    terminate_connections



    import :transformed_products do
      into :dim_product

      put :id => :item
      put :name => :title
    end
    """
    When I execute the definition
    Then the process should exit successfully
    And the "dim_product" table should contain:
      | item    | title                |
      | JNI-123 | Just a product name  |
      | CDI-234 | Another product name |
