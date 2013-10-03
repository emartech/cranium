Feature: Projection

  Scenario: Empty transformation projects down if the source structure is a superset of the target structure
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

    source :products_projected do
      field :id, String
      field :category, String
    end

    transform :products => :products_projected do end
    """
    When I execute the definition
    Then there is a "products_projected.csv" data file containing:
    """
    id,category
    JNI-123,Main category > Subcategory > Sub-subcategory
    CDI-234,Smart Insight > Cool stuff > Scripts
    """
