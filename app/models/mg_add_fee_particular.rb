class MgAddFeeParticular < ApplicationRecord
  belongs_to(:mg_add_fee_category)
  has_many :mg_add_fee_collections,  dependent: :destroy 
  validates(:name, { presence: true })
end
