class MgCbscExamSchedule < ApplicationRecord
  belongs_to(:mg_batch)
  belongs_to(:mg_school)
  belongs_to(:mg_subject)
  belongs_to(:mg_scholastic_exam_component)
  belongs_to(:mg_scholastic_exam_particular)
  belongs_to(:mg_course)
  belongs_to(:mg_cbsc_exam_type)
end
