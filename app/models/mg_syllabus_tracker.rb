class MgSyllabusTracker < ApplicationRecord
  belongs_to(:mg_employee)
  belongs_to(:mg_syllabus)
  belongs_to(:mg_unit)
  belongs_to(:mg_topic)
  belongs_to(:mg_batch)
  belongs_to(:mg_school)
  belongs_to(:mg_subject)
  belongs_to(:mg_wing)
  belongs_to(:mg_course)
end
