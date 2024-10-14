class MgSportsPayDeductiionList < ApplicationRecord
  belongs_to(:mg_employee)
  belongs_to(:mg_school)
end
