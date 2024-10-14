class MgInventoryItem < ApplicationRecord
  validates(:name, { uniqueness: { scope: [:mg_school_id, :is_deleted] } })
  validates(:code, { uniqueness: { scope: [:mg_school_id, :is_deleted] } })
  validates(:prefix, { uniqueness: { scope: [:mg_school_id, :is_deleted] } })
  belongs_to(:mg_school)
  has_many :mg_document_managements,  dependent: :destroy 
  has_many :mg_alumni_item_sale_details,  dependent: :destroy 
  has_many :mg_fee_categories,  dependent: :destroy 
  has_many :mg_fee_fine_particulars,  dependent: :destroy 
  has_many :mg_inventory_item_consumptions,  dependent: :destroy 
  has_many :mg_inventory_item_managements,  dependent: :destroy 
  has_many :mg_inventory_sales_data,  dependent: :destroy 
  has_many :mg_particular_types,  dependent: :destroy 
  has_many :mg_sports_item_consumptions,  dependent: :destroy 
  has_many :mg_sports_item_managements,  dependent: :destroy 
end
