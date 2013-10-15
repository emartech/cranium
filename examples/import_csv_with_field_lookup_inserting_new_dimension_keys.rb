require_relative 'config'

source :purchases do
  field :user_id, String
  field :amount, String
end

source :transformed_purchases do
  field :contact_key, Integer
  field :amount, String
end

transform :purchases => :transformed_purchases do |record|
  record[:contact_key] = lookup :contact_key,
                                from_table: :dim_contact,
                                match_column: :user_id,
                                to_value: record[:user_id],
                                if_not_found_then_insert: { contact_key: next_value_in_sequence("dim_contact_contact_key_seq"),
                                                            name: "Unknown contact #{record[:user_id]}" }
end

import :transformed_purchases do
  into :fct_purchases
  put :contact_key
  put :amount
end
