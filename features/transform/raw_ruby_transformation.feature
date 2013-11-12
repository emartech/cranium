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
      output record
    end
    """
    When I execute the definition
    Then there should be a "transformed_products.csv" data file in the upload directory containing:
    """
    item,title,category
    *JNI-123*,J,Main category > Subcategory > Sub-subcategory
    *CDI-234*,A,Smart Insight > Cool stuff > Scripts
    """


  Scenario: Records can be skipped
    Given a "products.csv" data file containing:
    """
    id
    1
    2
    3
    """
    And the following definition:
    """
    source :products do
      field :id, Integer
    end

    source :transformed_products do
      field :id, Integer
    end

    transform :products => :transformed_products do |record|
      output record unless "2" == record[:id]
    end
    """
    When I execute the definition
    Then there should be a "transformed_products.csv" data file in the upload directory containing:
    """
    id
    1
    3
    """
