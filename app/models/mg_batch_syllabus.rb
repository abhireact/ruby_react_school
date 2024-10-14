class MgBatchSyllabus < ApplicationRecord
  belongs_to(:mg_batch)
  belongs_to(:mg_syllabus)
  belongs_to(:mg_school)
  belongs_to(:mg_subject)
end
