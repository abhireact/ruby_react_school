class MgClassSectionChange < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_student)
  belongs_to(:mg_time_table_id)
end
