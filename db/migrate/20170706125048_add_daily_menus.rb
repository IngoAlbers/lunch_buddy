class AddDailyMenus < ActiveRecord::Migration[5.1]
  def change
    create_table :daily_menus do |t|
      t.datetime :date
      t.string :content
      t.string :restaurant
    end

    add_index :daily_menus, %i[date restaurant], unique: true
  end
end
