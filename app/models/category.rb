class Category < ActiveRecord::Base
	has_and_belongs_to_many :retailers
  belongs_to :gender
  has_many :subcategories

end
