class MgCbscCoScholasticExamParticular < ApplicationRecord
  belongs_to(:mg_School)
  has_many :mg_cbsc_final_co_scholastic_grades,  dependent: :destroy 
  has_many :mg_students,  through: :mg_cbsc_final_co_scholastic_grades, dependent: :destroy 
  has_many :mg_cbsc_other_marks_entries,  dependent: :destroy 
  has_many :mg_students,  through: :mg_cbsc_other_marks_entries, dependent: :destroy 
end
