class StudentMeasurement < ApplicationRecord
  belongs_to(:mg_student)
  belongs_to(:mg_time_table)
  belongs_to(:mg_course)
  belongs_to(:mg_batch)
  belongs_to(:cbsc_examtype)
end
