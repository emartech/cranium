Feature: When a csv is transformed by an empty transformation the copy has identical data

  Scenario: No transformation
    Given a "products.csv" data file containing:
    """
    id,name,category
    JNI-123,Just a product name,Main category > Subcategory > Sub-subcategory
    CDI-234,Another product name,Smart Insight > Cool stuff > Scripts
    """
    And the following definition:
    """
    source :products do end

    source :transformed_products do
      field :id, String
      field :name, String
      field :category, String
    end

    transform :products => :transformed_products do end
    """
    When I execute the definition
    Then there is a "transformed_products.csv" data file containing:
    """
    id,name,category
    JNI-123,Just a product name,Main category > Subcategory > Sub-subcategory
    CDI-234,Another product name,Smart Insight > Cool stuff > Scripts
    """


  Scenario: Quote and delimiter transformation
    Given a "products.csv" data file containing:
    """
    'id';'name';'category'
    'JNI-123';'Just a product name';'Main category > Subcategory > Sub-subcategory'
    'CDI-234';'Another product name';'Smart Insight > Cool stuff > Scripts'
    """
    And the following definition:
    """
    source :products do
     delimiter ';'
     quote "'"
    end

    source :transformed_products do
      field :id, String
      field :name, String
      field :category, String
    end

    transform :products => :transformed_products do end
    """
    When I execute the definition
    Then there is a "transformed_products.csv" data file containing:
    """
    id,name,category
    JNI-123,Just a product name,Main category > Subcategory > Sub-subcategory
    CDI-234,Another product name,Smart Insight > Cool stuff > Scripts
    """

