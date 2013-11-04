require_relative 'config'

source :sales_items do
  file "sales_items*.csv"
  field :order_id, String
  field :date, Date
  field :customer, Integer
  field :item, String
  field :item_name, String
  field :quantity, Float
  field :c_sales_amount, Float
end

source :products do
  field :item_id
  field :item_name
end


deduplicate :sales_items, into: :products, by: [:item]

# Equivalent to

transform :sales_items => :products do |record|
  deduplicate_by :item
end

