class MgInventorySalesInformation < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_inventory_item_category)
end
