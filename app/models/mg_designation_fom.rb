class MgDesignationFom < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_address_book_foms,  dependent: :destroy 
end
