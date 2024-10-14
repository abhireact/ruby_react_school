class MgAssignmentSubmission < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_assignment)
  belongs_to(:mg_student)
  belongs_to(:mg_subject)
end
