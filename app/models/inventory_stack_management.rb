class InventoryStackManagement < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_inventory_room_management)
  belongs_to(:mg_inventory_store_management)
  validates(:rack_no, { uniqueness: { scope: [:mg_school_id, :mg_inventory_room_management_id], conditions: lambda {
    where({ is_deleted: false })
  }, on: :create } })
  validates(:prefix, { uniqueness: { scope: [:mg_school_id, :mg_inventory_room_management_id], conditions: lambda {
    where({ is_deleted: false })
  }, on: :create } })
end
