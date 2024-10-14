class MgInventoryStoreManager < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_employee_department)
  belongs_to(:mg_employee)
  belongs_to(:mg_inventory_store_management)
  belongs_to(:mg_user)
  validates(:mg_inventory_store_management_id, { uniqueness: { scope: :mg_school_id, conditions: lambda {
    where({ is_deleted: false })
  }, on: :create } })
end
