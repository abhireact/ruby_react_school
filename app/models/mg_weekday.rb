class MgWeekday < ApplicationRecord
  belongs_to(:mg_wing)
  belongs_to(:mg_batch)
  belongs_to(:mg_school)
  has_many :mg_class_timings,  dependent: :destroy 
  has_many :mg_time_table_entries,  dependent: :destroy 
end
