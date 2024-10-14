class MgInventoryItemManagement < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_inventory_item)
  belongs_to(:mg_inventory_item_category)
end
