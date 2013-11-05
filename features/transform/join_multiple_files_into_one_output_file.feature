Feature: Join multiple files into one output file

  Scenario: Successful transformation
    Given a "products1.csv" data file containing:
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

    source :transformed_products do
      field :item, String
      field :title, String
      field :category, String
    end

    transform :products => :transformed_products do |record|
      record[:item] = record[:id]
      record[:title] = record[:name]
    end
    """
    When I execute the definition
    Then there should be a "transformed_products.csv" data file in the upload directory containing:
    """
    item,title,category
    PROD-1,product name 1,Main category > Subcategory > Sub-subcategory
    PROD-2,product name 2,Main category > Subcategory > Sub-subcategory
    PROD-3,product name 3,Main category > Subcategory > Sub-subcategory
    PROD-4,product name 4,Main category > Subcategory > Sub-subcategory
    """
