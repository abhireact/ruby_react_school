class MgAssessmentScore < ApplicationRecord
  belongs_to(:mg_student)
  belongs_to(:mg_exam)
  belongs_to(:mg_batch)
  belongs_to(:mg_school)
  belongs_to(:mg_descriptive_indicator)
end
