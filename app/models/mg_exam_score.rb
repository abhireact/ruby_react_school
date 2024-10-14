class MgExamScore < ApplicationRecord
  belongs_to(:mg_student)
  belongs_to(:mg_exam)
  belongs_to(:mg_grading_level)
  belongs_to(:mg_school)
end
