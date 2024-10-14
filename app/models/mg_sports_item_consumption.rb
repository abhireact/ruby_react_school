class MgSportsItemConsumption < ApplicationRecord
  belongs_to(:mg_employee)
  belongs_to(:mg_school)
  belongs_to(:mg_inventory_item)
  belongs_to(:mg_inventory_item_category)
  belongs_to(:mg_student)
end
