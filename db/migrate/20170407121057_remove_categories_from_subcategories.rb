class RemoveCategoriesFromSubcategories < ActiveRecord::Migration
  def change
    remove_column :subcategories, :category_id
  end
end
