class AddDailyMenus < ActiveRecord::Migration[5.1]
  def change
    create_table :daily_menus do |t|
      t.datetime :date, null: false
      t.string :content, null: false
      t.references :restaurant, index: true, null: false, foreign_key: { on_delete: :cascade }
    end

    add_index :daily_menus, %i[date restaurant_id], unique: true
  end
end
