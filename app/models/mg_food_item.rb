class MgFoodItem < ApplicationRecord
  has_many :mg_canteen_bill_payments,  dependent: :destroy 
  has_many :mg_canteen_meals,  dependent: :destroy 
  has_one :mg_canteen_regular_menus,  dependent: :destroy 
  belongs_to(:mg_school)
end
