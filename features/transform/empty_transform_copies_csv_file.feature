Feature: When a CSV is transformed by an empty transformation the copy has identical data

  Scenario: Empty transformation from the default CSV format simply copies the file
    Given a "products.csv" data file containing:
    """
    id,name,category
    JNI-123,Just a product name,Main category > Subcategory > Sub-subcategory
    CDI-234,Another product name,Smart Insight > Cool stuff > Scripts
    """
    And the following definition:
    """
    source :products do end

    source :products_copy do
      field :id, String
      field :name, String
      field :category, String
    end

    transform :products => :products_copy do end
    """
    When I execute the definition
    Then there is a "products_copy.csv" data file containing:
    """
    id,name,category
    JNI-123,Just a product name,Main category > Subcategory > Sub-subcategory
    CDI-234,Another product name,Smart Insight > Cool stuff > Scripts
    """


  Scenario: Empty transformation from custom CSV format converts quotes and delimiters to the default format
    Given a "products.csv" data file containing:
    """
    'id';'name';'category'
    'JNI-123';'Just a product name';'Main category > Subcategory > Sub-subcategory'
    'CDI-234';'Another 12" product name';'Smart Insight > Cool stuff > Scripts'
    """
    And the following definition:
    """
    source :products do
     delimiter ';'
     quote "'"
    end

    source :products_converted do
      field :id, String
      field :name, String
      field :category, String
    end

    transform :products => :products_converted do end
    """
    When I execute the definition
    Then there is a "products_converted.csv" data file containing:
    """
    id,name,category
    JNI-123,Just a product name,Main category > Subcategory > Sub-subcategory
    CDI-234,"Another 12"" product name",Smart Insight > Cool stuff > Scripts
    """

