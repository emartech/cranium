Feature: Import multiple CSV files into the database without any transformations

  Scenario: Successful import
    Given a database table called "dim_product" with the following fields:
      | field_name | field_type |
      | item       | TEXT       |
      | title      | TEXT       |
      | category   | TEXT       |
    And a "products1.csv" data file containing:
    """
    id,name,category
    PROD-1,product name 1,Main category > Subcategory > Sub-subcategory
    PROD-2,product name 2,Main category > Subcategory > Sub-subcategory
    """
    And a "products2.csv" data file containing:
    """
    id,name,category
    PROD-3,product name 3,Main category > Subcategory > Sub-subcategory
    PROD-4,product name 4,Main category > Subcategory > Sub-subcategory
    """
    And the following definition:
    """
    source :products do
      file "products*.csv"
      field :id, String
      field :name, String
      field :category, String
    end

    import :products do
      into :dim_product
      put :id => :item
      put :name => :title
      put :category => :category
    end
    """
    When I execute the definition
    Then the "dim_product" table should contain:
      | item   | title          | category                                      |
      | PROD-1 | product name 1 | Main category > Subcategory > Sub-subcategory |
      | PROD-2 | product name 2 | Main category > Subcategory > Sub-subcategory |
      | PROD-3 | product name 3 | Main category > Subcategory > Sub-subcategory |
      | PROD-4 | product name 4 | Main category > Subcategory > Sub-subcategory |
