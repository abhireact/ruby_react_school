class MgLibraryFine < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_library_fine_dues,  dependent: :destroy 
  accepts_nested_attributes_for(:mg_library_fine_dues)
end
