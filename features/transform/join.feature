Feature: Joining CSV files

  Scenario: Singe file transformation
    Given an "orders.csv" data file containing:
    """
    id,order_date,customer_id,total_price
    order_1,2011-01-01,customer_1,100
    order_2,2011-02-02,customer_1,200
    order_3,2011-03-03,customer_2,300
    """
    Given an "order_items.csv" data file containing:
    """
    order_id,item_id,item_name,item_category,quantity,sales_amount,comment
    order_1,item_1,first item,clothing,1,5,some useful comment
    order_1,item_2,second item,communication,2,6,not so useful comment
    order_2,item_2,second item,communication,5,12,very misleading comment
    """
    And the following definition:
    """
    source :orders_file do
      file "orders.csv"

      field :id, String
      field :order_date, Date
      field :customer_id, String
      field :total_price, Integer
    end

    source :order_items_file do
      file "order_items.csv"

      field :order_id, String
      field :item_id, String
      field :item_name, String
      field :item_category, String
      field :quantity, Integer
      field :sales_amount, Integer
      field :comment, String
    end

    source :sales_items do
      field :order_id, String
      field :order_date, String
      field :new_field, String
      field :customer_id, String
      field :item_id, String
      field :item_name, String
      field :item_category, String
      field :quantity, String
      field :sales_amount, String
    end

    join :orders_file, with: :order_items_file, into: :sales_items, match_on: { :order_id => :id }
    """
    When I execute the definition
    Then the process should exit successfully
    And there should be a "sales_items.csv" data file in the upload directory containing:
    """
    order_id,order_date,new_field,customer_id,item_id,item_name,item_category,quantity,sales_amount
    order_1,2011-01-01,,customer_1,item_1,first item,clothing,1,5
    order_1,2011-01-01,,customer_1,item_2,second item,communication,2,6
    order_2,2011-02-02,,customer_1,item_2,second item,communication,5,12
    """


  Scenario: File transformation with left join
    Given an "orders.csv" data file containing:
    """
    id,order_date,customer_id,total_price
    order_1,2011-01-01,customer_1,100
    order_2,2011-02-02,customer_1,200
    order_3,2011-03-03,customer_2,300
    """
    Given an "order_items.csv" data file containing:
    """
    order_id,item_id,item_name,item_category,quantity,sales_amount,comment
    order_1,item_1,first item,clothing,1,5,some useful comment
    order_1,item_2,second item,communication,2,6,not so useful comment
    order_2,item_2,second item,communication,5,12,very misleading comment
    """
    And the following definition:
    """
    source :orders_file do
      file "orders.csv"

      field :id, String
      field :order_date, Date
      field :customer_id, String
      field :total_price, Integer
    end

    source :order_items_file do
      file "order_items.csv"

      field :order_id, String
      field :item_id, String
      field :item_name, String
      field :item_category, String
      field :quantity, Integer
      field :sales_amount, Integer
      field :comment, String
    end

    source :sales_items do
      field :id, String
      field :item_id, String
      field :item_name, String
      field :order_date, String
      field :customer_id, String
      field :item_category, String
      field :quantity, String
      field :sales_amount, String
    end

    join :orders_file, with: :order_items_file, into: :sales_items, match_on: { :order_id => :id }, type: :left
    """
    When I execute the definition
    Then the process should exit successfully
    And there should be a "sales_items.csv" data file in the upload directory containing:
    """
    id,item_id,item_name,order_date,customer_id,item_category,quantity,sales_amount
    order_1,item_1,first item,2011-01-01,customer_1,clothing,1,5
    order_1,item_2,second item,2011-01-01,customer_1,communication,2,6
    order_2,item_2,second item,2011-02-02,customer_1,communication,5,12
    order_3,,,2011-03-03,customer_2,,,
    """
