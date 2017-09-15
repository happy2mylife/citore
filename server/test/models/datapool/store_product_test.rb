# == Schema Information
#
# Table name: datapool_store_products
#
#  id            :integer          not null, primary key
#  type          :string(255)
#  product_id    :string(255)      not null
#  title         :string(255)      not null
#  url           :string(255)      not null
#  icon_url      :string(255)
#  review_count  :integer          default(0), not null
#  average_score :float(24)        default(0.0), not null
#  options       :text(65535)
#
# Indexes
#
#  store_product_unique_index  (product_id,type) UNIQUE
#  store_product_url_index     (url)
#

require 'test_helper'

class Datapool::StoreProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
