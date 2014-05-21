Feature: Import data and assign a load id (audit information) from a sequence to all records

  Scenario: Successful import
    Given a database table called "dim_product" with the following fields:
      | field_name | field_type |
      | load_id    | INTEGER    |
      | item       | TEXT       |
      | title      | TEXT       |
    And a sequence called "some_sequence" starting from 33
    And a "products.csv" data file containing:
    """
    id,name,category
    JNI-123,Just a product name,Main category > Subcategory > Sub-subcategory > Ultra-subcategory
    CDI-234,Another product name,Smart Insight > Cool stuff | 3dim > 2dim > 1dim
    """
    And the following definition:
    """
    LOAD_ID = sequence("some_sequence").next_value

    source :products do
      encoding "UTF-8"
      delimiter ','

      field :id, String
      field :name, String
    end

    source :transformed_products do
      field :load_id, Integer

      field :id, String
      field :name, String
    end

    transform :products => :transformed_products do |record|
      record[:load_id] = LOAD_ID
      output record
    end

    import :transformed_products do
      into :dim_product

      put :load_id
      put :id => :item
      put :name => :title
    end
    """
    When I execute the definition
    Then the "dim_product" table should contain:
      | load_id (i) | item    | title                |
      | 34          | JNI-123 | Just a product name  |
      | 34          | CDI-234 | Another product name |
