class MgParticularType < ApplicationRecord
  belongs_to(:mg_school)
  # belongs_to(:mg_inventory_item)
  belongs_to(:mg_fee_category)
  has_many :mg_fee_particulars,  dependent: :destroy 
  has_many :mg_batches,  through: :mg_fee_particulars, dependent: :destroy 
  validates(:particular_name, { uniqueness: { scope: [:mg_school_id, :mg_fee_category_id], conditions: lambda {
    where({ is_deleted: false })
  } } })
end
