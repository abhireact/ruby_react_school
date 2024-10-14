class MgAlumniGetTogether < ApplicationRecord
  belongs_to(:mg_wing)
  belongs_to(:mg_school)
  belongs_to(:mg_user)
  has_many :mg_get_togethers,  dependent: :destroy 
  has_many :mg_alumnis,  through: :mg_get_togethers, dependent: :destroy 
end
