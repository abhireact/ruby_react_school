class MgScholasticExamComponent < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_scholastic_exam_particular)
  has_many :mg_cbsc_exam_schedules,  dependent: :destroy 
  has_many :mg_cbsc_scholastic_marks_entries,  dependent: :destroy 
end
