class MgInventoryRoomManagement < ApplicationRecord
  belongs_to(:mg_school)
  has_many :inventory_stack_managements,  dependent: :destroy 
  belongs_to(:mg_inventory_store_management)
end
