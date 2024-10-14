class MgInventoryProposal < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_employee)
  has_many :mg_inventory_proposal_items,  dependent: :destroy 
end
