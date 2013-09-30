@wip
Feature: Import a CSV file into the database without any transformations

  Scenario: Successful import
    Given a database table called "dim_product" with the following fields:
      | field_name | field_type |
      | item       | TEXT       |
      | title      | TEXT       |
      | category   | TEXT       |
    And a "products.csv" data file containing:
    """
    item,title,category
    JNI-123,Just a product name,Main category > Subcategory > Sub-subcategory
    CDI-234,Another product name,Smart Insight > Cool stuff > Scripts
    """
    And the following definition:
    """
    source :products do
      field :item, String
      field :title, String
      field :category, String
    end

    import :products do
      to :dim_product
      put :item => :id
      put :title => :name
      put :category => :category
    end
    """
    When I execute the definition
    Then the "dim_product" table should contain:
      | item | title                | category                                      |
      | 1    | Just a product name  | Main category > Subcategory > Sub-subcategory |
      | 2    | Another product name | Smart Insight > Cool stuff > Scripts          |
