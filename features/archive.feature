Feature: Archive source files

  Scenario: Successful transformation
    Given no "/tmp/cranium_archive" directory
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
      file "products*.csv"
    end

    source :contacts do
      file "contacts*.csv"
    end

    source :purchases do
      file "purchases*.csv"
    end

    archive :products, :contacts
    """
    When I execute the definition
    Then the "/tmp/cranium_archive/" directory should contain 3 files
