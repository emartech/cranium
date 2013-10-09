Feature: Archive source files

  Scenario: Successful transformation
    Given no "/tmp/cranium_archive" directory
    And a "products_1.csv" data file containing:
    """
    id,name,category
    PROD-1,product name 1,Main category > Subcategory > Sub-subcategory
    PROD-2,product name 2,Main category > Subcategory > Sub-subcategory
    """
    And a "products_2.csv" data file containing:
    """
    id,name,category
    PROD-3,product name 3,Main category > Subcategory > Sub-subcategory
    PROD-4,product name 4,Main category > Subcategory > Sub-subcategory
    """
    And a "contacts.csv" data file containing:
    """
    id,name
    CON-1,Contact Alpha
    CON-2,Contact Beta
    """
    And a "purchases.csv" data file containing:
    """
    id,contact_id,product_id
    PUR-1,CON-1,PROD-1
    PUR-2,CON-2,PROD-2
    """
    And the following definition:
    """
    Cranium.configure do |config|
      config.archive_directory = "/tmp/cranium_archive"
    end

    source :products do
      file "products*.csv"
      field :id, String
      field :name, String
      field :category, String
    end

    source :contacts do
      file "contacts*.csv"
      field :id, String
      field :name, String
    end

    source :purchases do
      file "purchases*.csv"
      field :id, String
      field :name, String
    end

    archive :products, :contacts
    """
    When I execute the definition
    Then there is a "/tmp/cranium_archive/products_1.csv" data file containing:
    """
    id,name,category
    PROD-1,product name 1,Main category > Subcategory > Sub-subcategory
    PROD-2,product name 2,Main category > Subcategory > Sub-subcategory
    """
    And there is a "/tmp/cranium_archive/products_2.csv" data file containing:
    """
    id,name,category
    PROD-3,product name 3,Main category > Subcategory > Sub-subcategory
    PROD-4,product name 4,Main category > Subcategory > Sub-subcategory
    """
    And there is a "/tmp/cranium_archive/contacts.csv" data file containing:
    """
    id,name
    CON-1,Contact Alpha
    CON-2,Contact Beta
    """
