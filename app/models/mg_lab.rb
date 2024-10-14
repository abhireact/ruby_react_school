class MgLab < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_laboratory_subject)
  has_many :mg_inventory_managements,  dependent: :destroy 
  has_many :mg_item_consumptions,  dependent: :destroy 
  has_many :mg_item_purchases,  dependent: :destroy 
  has_many :mg_lab_inventories,  dependent: :destroy 
  has_many :mg_students,  through: :mg_item_consumptions, dependent: :destroy 
end
