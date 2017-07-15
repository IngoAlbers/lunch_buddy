# frozen_string_literal: true

class CreateRestaurants < ActiveRecord::Migration[5.1]
  def change
    create_table :restaurants do |t|
      t.string :type, null: false
    end

    add_index :restaurants, :type, unique: true
  end
end
