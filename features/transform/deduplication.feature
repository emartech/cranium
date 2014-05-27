Feature: Deduplicate data in CSV file

  Scenario: Singe file transformation
    Given a "sales_items.csv" data file containing:
    """
    order_id,item,item_name
    1,Item1,Item name 1
    2,Item1,Item name 1
    3,Item2,Item name 2
    4,Item2,Item name 2
    5,Item3,Item name 3
    """
    And the following definition:
    """
    source :sales_items do
      file "sales_items.csv"
      field :order_id, String
      field :item, String
      field :item_name, String
    end

    source :products do
      field :item, String
      field :item_name, String
    end

    deduplicate :sales_items, into: :products, by: [:item]
    """
    When I execute the definition
    Then the process should exit successfully
    And there should be a "products.csv" data file in the upload directory containing:
    """
    item,item_name
    Item1,Item name 1
    Item2,Item name 2
    Item3,Item name 3
    """
