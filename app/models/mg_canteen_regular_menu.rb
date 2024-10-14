class MgCanteenRegularMenu < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_food_item)
end
