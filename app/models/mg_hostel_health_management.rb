class MgHostelHealthManagement < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_hostel_floor)
  belongs_to(:mg_student)
  belongs_to(:mg_hostel_room)
end
