@wip
Feature: Sequel database connections are fault tolerant using PoolCleaner
  Scenario:
    Given no "/tmp/cranium_archive" directory
    And a "products_2.csv" data file containing:
    """
    id,name,category
    JNI-123,Just a product name,Main category > Subcategory > Sub-subcategory > Ultra-subcategory
    """
    And the following definition:
    """
    source :products do
      file "products_*.csv"
    end

    source :products_transformed do end

    transform :products => :products_transformed do |record|
      connection = Cranium::Database.connection
      procpid = connection.fetch("SELECT procpid FROM pg_stat_activity").first[:procpid]
      connection.run("SELECT PG_TERMINATE_BACKEND(#{procpid})")
      output record
    end
    """
    When I execute the definition
    Then the process should exit successfully
