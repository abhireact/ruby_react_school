class MgCbscFinalCoScholasticGrade < ApplicationRecord
  belongs_to(:mg_batch)
  belongs_to(:mg_school)
  belongs_to(:mg_cbsc_co_scholastic_exam_particular)
  belongs_to(:mg_student)
  belongs_to(:mg_cbsc_co_scholastic_grade)
  belongs_to(:mg_cbsc_exam_type)
end
