class MgCanteen < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_canteen_meals,  dependent: :destroy 
end
