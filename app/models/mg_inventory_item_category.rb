class MgInventoryItemCategory < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_fee_categories,  dependent: :destroy 
  has_many :mg_inventory_item_consumptions,  dependent: :destroy 
  has_many :mg_inventory_item_managements,  dependent: :destroy 
  has_many :mg_inventory_sales_informations,  dependent: :destroy 
  has_many :mg_sports_item_consumptions,  dependent: :destroy 
  has_many :mg_sports_item_managements,  dependent: :destroy 
  validates(:name, { uniqueness: { scope: [:mg_school_id, :is_deleted] } })
end
