class MgInventoryItemCategory < ActiveRecord::Base
  belongs_to :mg_school
  has_many :mg_fee_categories
  has_many :mg_inventory_item_consumptions
  has_many :mg_inventory_item_managements
  has_many :mg_inventory_sales_informations
  has_many :mg_sports_item_consumptions
  has_many :mg_sports_item_managements
  validates :name, :uniqueness => {:scope => [:mg_school_id, :is_deleted]}
end 