class MgGroupedExam < ApplicationRecord
  belongs_to(:mg_exam_group)
  belongs_to(:mg_batch)
  belongs_to(:mg_school)
end
