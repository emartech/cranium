Feature: Import a CSV file into the database as a delta

  Scenario: Successful import
    Given a database table called "dim_product" with the following fields:
      | field_name  | field_type |
      | item        | TEXT       |
      | title       | TEXT       |
      | category    | TEXT       |
      | description | TEXT       |
    And a "products.csv" data file containing:
    """
    id,name,category,description
    JNI-123,Just a product name,Main category > Subcategory > Sub-subcategory,Some description
    CDI-234,Another product name,Smart Insight > Cool stuff > Scripts,Another description
    """
    And the following definition:
    """
    source :products do
      field :id, String
      field :name, String
      field :category, String
      field :description, String
    end

    import :products do
      into :dim_product
      put :id => :item
      put :name => :title
      put :category => :category
      put :description => :description
    end
    """
    When I execute the definition
    Then the "dim_product" table should contain:
      | item    | title                | category                                      | description         |
      | JNI-123 | Just a product name  | Main category > Subcategory > Sub-subcategory | Some description    |
      | CDI-234 | Another product name | Smart Insight > Cool stuff > Scripts          | Another description |
