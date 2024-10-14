class MgCommitteeMember < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_employee)
  belongs_to(:mg_student)
  belongs_to(:mg_event_committee)
end
