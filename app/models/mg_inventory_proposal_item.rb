class MgInventoryProposalItem < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_inventory_proposal)
  has_many :mg_inventory_vendors,  dependent: :destroy 
end
