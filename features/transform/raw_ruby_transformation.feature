Feature: Raw Ruby transformation

  Scenario: A transform block can use the record as a Hash
    Given a "products.csv" data file containing:
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

    source :transformed_products do
      field :item, String
      field :title, String
      field :category, String
    end

    transform :products => :transformed_products do |record|
      record[:item] = "*#{record[:id]}*"
      record[:title] = record[:name].chars.first
    end
    """
    When I execute the definition
    Then there is a "transformed_products.csv" data file containing:
    """
    item,title,category
    *JNI-123*,J,Main category > Subcategory > Sub-subcategory
    *CDI-234*,A,Smart Insight > Cool stuff > Scripts
    """