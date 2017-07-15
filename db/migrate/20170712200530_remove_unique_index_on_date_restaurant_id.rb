# frozen_string_literal: true

class RemoveUniqueIndexOnDateRestaurantId < ActiveRecord::Migration[5.1]
  def change
    remove_index :daily_menus, %i[date restaurant_id]
  end
end
