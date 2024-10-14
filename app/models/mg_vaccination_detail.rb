class MgVaccinationDetail < ApplicationRecord
  belongs_to(:mg_vaccination)
  belongs_to(:mg_batch)
  belongs_to(:mg_school)
  belongs_to(:mg_student)
end
