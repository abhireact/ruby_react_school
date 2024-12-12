class MgCbscCoScholasticGrade < ApplicationRecord
  # belongs_to(:mg_batch)
  # belongs_to(:mg_school)
  has_many :mg_cbsc_final_co_scholastic_grades,  dependent: :destroy 
  has_many :mg_cbsc_other_marks_entries,  dependent: :destroy 
end
