class MgCanteenMeal < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_canteen)
  belongs_to(:mg_food_item)
  belongs_to(:mg_meal_category)
end
