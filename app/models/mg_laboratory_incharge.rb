class MgLaboratoryIncharge < ApplicationRecord
  belongs_to(:mg_subject)
  belongs_to(:mg_school)
  belongs_to(:mg_user)
end
