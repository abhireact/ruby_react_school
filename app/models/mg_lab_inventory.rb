class MgLabInventory < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_lab)
  belongs_to(:mg_laboratory_item)
end
