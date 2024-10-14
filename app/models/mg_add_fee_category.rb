class MgAddFeeCategory < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_add_fee_particulars,  dependent: :destroy 
  has_many :mg_add_fee_collections,  dependent: :destroy 
  accepts_nested_attributes_for(:mg_add_fee_particulars, { reject_if: :all_blank, allow_destroy: true })
  validates(:name, { presence: true })
end
