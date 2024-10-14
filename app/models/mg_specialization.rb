class MgSpecialization < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_users,  dependent: :destroy 
end
