class MgInventoryVendor < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_inventory_proposal_item)
end
