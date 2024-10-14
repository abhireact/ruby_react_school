class MgComplainHostel < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_student)
  belongs_to(:mg_hostel_detail)
end
