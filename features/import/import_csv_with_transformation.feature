Feature: Import a CSV file into the database with a split transformation

  Scenario: Successful import
    Given a database table called "dim_product" with the following fields:
      | field_name | field_type |
      | item       | TEXT       |
      | title      | TEXT       |
      | category1  | TEXT       |
      | category2  | TEXT       |
      | category3  | TEXT       |
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
      field :category, String
    end

    source :transformed_products do
      field :id, String
      field :name, String
      field :main_category, String
      field :sub_category, String
      field :department, String
    end

    transform :products => :transformed_products do |record|
      record.split_field :category, into: [:category], by: "|"
      record.split_field :category, into: [:main_category, :sub_category, :department], by: ">"
    end

    import :transformed_products do
      to :dim_product
      put :id => :item
      put :name => :title
      put :main_category => :category1
      put :sub_category => :category2
      put :department => :category3
    end
    """
    When I execute the definition
    Then the "dim_product" table should contain:
      | item    | title                | category1     | category2   | category3       |
      | JNI-123 | Just a product name  | Main category | Subcategory | Sub-subcategory |
      | CDI-234 | Another product name | Smart Insight | Cool stuff  | Cool stuff      |
