class CreateFoodForecastHealthFoods < ActiveRecord::Migration[5.1]
  def change
    create_table :food_forecast_health_foods do |t|
      t.integer :mst_health_id, null: false
      t.integer :mst_food_id, null: false
      t.float :weight, null: false, default: 1
    end

    add_index :food_forecast_health_foods, [:mst_health_id, :mst_food_id], name: "health_food_relation_index"
  end
end
