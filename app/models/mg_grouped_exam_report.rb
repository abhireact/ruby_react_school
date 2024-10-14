class MgGroupedExamReport < ApplicationRecord
  belongs_to(:mg_exam_group)
  belongs_to(:mg_subject)
  belongs_to(:mg_batch)
  belongs_to(:mg_school)
  belongs_to(:mg_student)
end
