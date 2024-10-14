class MgTimeTableEntry < ApplicationRecord
  belongs_to(:mg_batch)
  belongs_to(:mg_weekday)
  belongs_to(:mg_time_table)
  belongs_to :mg_class_timing,  foreign_key: "mg_class_timings_id", primary_key: "id" 
  belongs_to(:mg_subject)
  belongs_to(:mg_employee)
  belongs_to(:mg_school)
  has_many :mg_time_table_change_entries,  dependent: :destroy 
  delegate :weekday, to: :mg_weekday
end
