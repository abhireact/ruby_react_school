class MgBoosterDoseDetail < ApplicationRecord
  belongs_to(:mg_booster_dose)
  belongs_to(:mg_school)
  belongs_to(:mg_student)
  belongs_to(:mg_time_table)
  belongs_to(:mg_batch)
end
