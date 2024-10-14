class MgLaboratoryItem < ApplicationRecord
  has_many :mg_lab_inventories,  dependent: :destroy 
  belongs_to(:mg_school)
end
