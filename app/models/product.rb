require 'aws-record'

class Product
  include Aws::Record
  set_table_name "products"

  string_attr   :uuid, hash_key: true
  string_attr   :title
  string_attr   :description
  string_attr   :image_url
end
