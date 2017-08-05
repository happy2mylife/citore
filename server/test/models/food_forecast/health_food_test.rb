# == Schema Information
#
# Table name: food_forecast_health_foods
#
#  id            :integer          not null, primary key
#  mst_health_id :integer          not null
#  mst_food_id   :integer          not null
#  weight        :float(24)        default(1.0), not null
#
# Indexes
#
#  health_food_relation_index  (mst_health_id,mst_food_id)
#

require 'test_helper'

class FoodForecast::HealthFoodTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
