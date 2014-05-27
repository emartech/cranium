Feature: Output rows to file

  Background:
    Given a "products.csv" data file containing:
    """
    id,name
    1,Product 1
    2, Product 2
    """

  Scenario: Output Hash instead of record
    Given the following definition:
    """
    source :products do
      field :id, String
      field :name, String
    end

    source :products_copy do
      field :id, String
      field :name, String
    end

    transform :products => :products_copy do |record|
      output name: record[:name],
             id: record[:id]
    end
    """
    When I execute the definition
    Then the process should exit successfully
    And there should be a "products_copy.csv" data file in the upload directory containing:
    """
    id,name
    1,Product 1
    2,Product 2
    """


  Scenario: Output multiple records for each input row
    Given the following definition:
    """
    source :products do
      field :id, String
      field :name, String
    end

    source :products_doubled do
      field :id, String
      field :name, String
      field :counter, Integer
    end

    transform :products => :products_doubled do |record|
      record[:counter] = 1
      output record
      record[:counter] = 2
      output record
    end
    """
    When I execute the definition
    Then the process should exit successfully
    And there should be a "products_doubled.csv" data file in the upload directory containing:
    """
    id,name,counter
    1,Product 1,1
    1,Product 1,2
    2,Product 2,1
    2,Product 2,2
    """

