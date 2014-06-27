Feature: Remove source files

  Scenario:
    Given a "contacts_extract_1.csv" data file containing:
    """
    """
    And a "contacts_extract_2.csv" data file containing:
    """
    """
    And a "clicks_extract_1.csv" data file containing:
    """
    """
    And a "products.csv" data file containing:
    """
    """
    And the following definition:
    """
    source :contacts_extract do
      file "contacts_extract_*.csv"
    end

    source :clicks_extract do
      file "clicks_extract_*.csv"
    end

    source :products do
      file "products.csv"
    end

    source :products_transformed do end

    transform :products => :products_transformed do |record|
      output record
    end

    remove :contacts_extract, :clicks_extract
    """
    When I execute the definition
    Then the process should exit successfully
    And the upload directory should contain the following files:
      | filename                 |
      | definition.rb            |
      | products.csv             |
      | products_transformed.csv |