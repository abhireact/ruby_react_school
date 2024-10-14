class MgFeeFine < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_fee_collections,  dependent: :destroy 
  has_many :mg_fee_fine_dues,  dependent: :destroy 
  accepts_nested_attributes_for(:mg_fee_fine_dues)
end
