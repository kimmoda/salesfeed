class RemoveGenderFromCategories < ActiveRecord::Migration
  def change
    remove_column :categories, :gender
  end
end
