Feature: Split field

  Scenario: A single field can be split into multiple fields
    Given a "products.csv" data file containing:
    """
    id,name,category
    JNI-123,Just a product name,Main category > Subcategory > Sub-subcategory > Ultra-subcategory
    CDI-234,Another product name,Smart Insight > Cool stuff | 3dim > 2dim > 1dim
    """
    And the following definition:
    """
    source :products do
      field :item, String
      field :title, String
      field :category, String
    end

    source :transformed_products do
      field :item, String
      field :title, String
      field :main_category, String
      field :sub_category, String
      field :department, String
    end

    transform :products => :transformed_products do |record|
      record.split_field :category, into: [:category], by: "|"
      record.split_field :category, into: [:main_category, :sub_category, :department], by: ">"
      output record
    end
    """
    When I execute the definition
    Then the process should exit successfully
    And there should be a "transformed_products.csv" data file in the upload directory containing:
    """
    item,title,main_category,sub_category,department
    JNI-123,Just a product name,Main category,Subcategory,Sub-subcategory
    CDI-234,Another product name,Smart Insight,Cool stuff,Cool stuff
    """
