class MgInventoryStoreManagement < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_employee)
  has_many :mg_inventory_store_managers,  dependent: :destroy 
  has_many :mg_employees,  through: :mg_inventory_store_managers, dependent: :destroy 
  has_many :mg_users,  through: :mg_inventory_store_managements, dependent: :destroy 
  has_many :inventory_stack_managements,  dependent: :destroy 
  has_many :mg_inventory_room_managements,  dependent: :destroy 
  validates(:store_name, { uniqueness: { scope: [:mg_school_id] } })
end
