class MgTimeTableChangeEntry < ApplicationRecord
  belongs_to(:mg_time_table_entry)
  belongs_to(:mg_school)
  belongs_to(:mg_subject)
  belongs_to(:mg_employee)
  belongs_to(:mg_batch)
  belongs_to(:mg_class_timing)
  belongs_to :mg_time_table,  foreign_key: :mg_timetable_id, primary_key: "id" 
end
