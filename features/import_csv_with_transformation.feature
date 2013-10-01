@wip
Feature: Import a CSV file into the database with a split transformation

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
    source :original_products do
      encoding "UTF-8"
      delimiter ','
      field :id, String
      field :name, String
      field :category, String
    end

    source :products do
      field :item, String
      field :title, String
      field :main_category, String
      field :sub_category, String
      field :department, String
    end

    transform :original_products => :products do |record|
      record.split_field! :category, into: [:main_category, :sub_category, :department], by: ">"
    end

    import :products do
      to :warehouse__dim_product
      put :item => :id
      put :title => :name
      put :main_category => :category1
      put :sub_category => :category2
      put :department => :category3
    end
    """
    When I execute the definition
    Then the "dim_product" table should contain:
      | item    | title                | category                                      |
      | JNI-123 | Just a product name  | Main category > Subcategory > Sub-subcategory |
      | CDI-234 | Another product name | Smart Insight > Cool stuff > Scripts          |
