class MgAttendanceSetting < ApplicationRecord
  belongs_to(:mg_wing)
  belongs_to(:mg_school)
end
