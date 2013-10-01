Feature: Import a CSV file into the database without any transformations

  Scenario: Successful import
    Given a database table called "dim_product" with the following fields:
      | field_name | field_type |
      | item       | TEXT       |
      | title      | TEXT       |
      | category   | TEXT       |
    And a "products.csv" data file containing:
    """
    id,name,category
    JNI-123,Just a product name,Main category > Subcategory > Sub-subcategory
    CDI-234,Another product name,Smart Insight > Cool stuff > Scripts
    """
    And the following definition:
    """
    source :products do
      field :id, String
      field :name, String
      field :category, String
    end

    import :products do
      to :dim_product
      put :id => :item
      put :name => :title
      put :category => :category
    end
    """
    When I execute the definition
    Then the "dim_product" table should contain:
      | item    | title                | category                                      |
      | JNI-123 | Just a product name  | Main category > Subcategory > Sub-subcategory |
      | CDI-234 | Another product name | Smart Insight > Cool stuff > Scripts          |
