class MgFaqCategory < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_inventory_item)
end
