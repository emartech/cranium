Feature: Archive source files

  Scenario:
    Given no "/tmp/cranium_archive" directory
    And no "/tmp/cranium_storage" directory
    And a "products_1.csv" data file containing:
    """
    """
    And a "products_2.csv" data file containing:
    """
    """
    And a "contacts.csv" data file containing:
    """
    """
    And a "purchases.csv" data file containing:
    """
    """
    And the following definition:
    """
    Cranium.configure do |config|
      config.archive_directory = "/tmp/cranium_archive"
    end

    source :products do
      file "products_*.csv"
    end

    source :products_transformed do end

    source :contacts do
      file "contacts.csv"
    end

    source :purchases do
      file "purchases.csv"
    end

    transform :products => :products_transformed do |record|
      output record
    end

    archive :products, :contacts

    move :purchases, to: "/tmp/cranium_storage"
    """
    When I execute the definition
    Then the process should exit successfully
    And the "/tmp/cranium_archive/" directory should contain the following files:
      | filename         |
      | .*contacts.csv   |
      | .*products_1.csv |
      | .*products_2.csv |
    And the "/tmp/cranium_storage" directory should contain the following files:
      | filename      |
      | purchases.csv |
