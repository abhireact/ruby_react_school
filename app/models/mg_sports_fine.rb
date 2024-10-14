class MgSportsFine < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_account)
  belongs_to(:mg_student)
end
