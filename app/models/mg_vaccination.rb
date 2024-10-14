class MgVaccination < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_vaccination_details,  dependent: :destroy 
  has_many :mg_students,  through: :mg_vaccination_details, dependent: :destroy 
  belongs_to(:mg_time_table)
end
