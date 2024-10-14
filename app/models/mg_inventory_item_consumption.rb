class MgInventoryItemConsumption < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_employee)
  belongs_to(:mg_inventory_item_category)
  belongs_to(:mg_inventory_item)
  has_many :mg_inventory_issued_item_consumptions,  dependent: :destroy 
  has_many :mg_inventory_item_damageds,  dependent: :destroy 
  has_many :mg_inventory_item_returns,  dependent: :destroy 
  belongs_to(:student)
end
