class CreateSubcategories < ActiveRecord::Migration
  def change
    create_table :subcategories do |t|
      t.string :name
      t.belongs_to :category, index: true

      t.timestamps null: false
    end
    add_index :subcategories, :name
  end
end
