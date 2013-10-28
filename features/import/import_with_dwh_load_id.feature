Feature: Import a CSV file into the database with a split transformation

  Scenario: Successful import
    Given a database table called "dim_product" with the following fields:
      | field_name  | field_type |
      | dwh_load_id | INTEGER    |
      | item        | TEXT       |
      | title       | TEXT       |
    And a sequence called "some_sequence" starting from 33
    And a "products.csv" data file containing:
    """
    id,name,category
    JNI-123,Just a product name,Main category > Subcategory > Sub-subcategory > Ultra-subcategory
    CDI-234,Another product name,Smart Insight > Cool stuff | 3dim > 2dim > 1dim
    """
    And the following definition:
    """
    source :products do
      encoding "UTF-8"
      delimiter ','

      field :id, String
      field :name, String
    end

    source :transformed_products do
      field :dwh_load_id, Integer

      field :id, String
      field :name, String
    end

    transform :products => :transformed_products do |record|
      @load_id ||= sequence("some_sequence").next_value
      record[:dwh_load_id] = @load_id
    end

    import :transformed_products do
      into :dim_product

      put :dwh_load_id => :dwh_load_id
      put :id => :item
      put :name => :title
    end
    """
    When I execute the definition
    Then the "dim_product" table should contain:
      | dwh_load_id (i) | item    | title                |
      | 33              | JNI-123 | Just a product name  |
      | 33              | CDI-234 | Another product name |
