class MgInventoryProjectionItem < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_inventory_projection)
end
