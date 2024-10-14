class MgInventoryItemDamaged < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_employee)
  belongs_to(:mg_inventory_item_consumption)
  belongs_to(:mg_student)
end
