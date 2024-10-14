class MgFeeCategory < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_inventory_item_category)
  belongs_to(:mg_account)
  has_many :mg_library_settings,  dependent: :destroy 
  has_many :mg_fee_discounts,  dependent: :destroy 
  has_many :mg_finance_transactions,  dependent: :destroy 
  has_many :mg_fee_collections,  dependent: :destroy 
  has_many :mg_particular_types,  dependent: :destroy 
  has_many :mg_batches,  through: :mg_fee_collections, dependent: :destroy 
  has_many :mg_fee_category_batches,  dependent: :destroy 
  accepts_nested_attributes_for(:mg_fee_category_batches)
  has_many :mg_fee_particulars,  dependent: :destroy 
  accepts_nested_attributes_for(:mg_fee_particulars)
end
