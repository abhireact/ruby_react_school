class MgInventoryProjection < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_employee)
  has_many :mg_inventory_projection_items,  dependent: :destroy 
end
