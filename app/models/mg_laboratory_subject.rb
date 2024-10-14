class MgLaboratorySubject < ApplicationRecord
  has_many :mg_labs,  dependent: :destroy 
  has_many :mg_item_purchases,  dependent: :destroy 
  has_many :mg_item_consumptions,  dependent: :destroy 
  has_many :mg_inventory_managements,  dependent: :destroy 
  has_many :mg_fee_fine_particulars,  dependent: :destroy 
  belongs_to(:mg_school)
end
