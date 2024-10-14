class MgDisciplinaryActionStudent < ApplicationRecord
  belongs_to(:mg_batch)
  belongs_to(:mg_school)
  belongs_to(:mg_disciplinary_action)
  belongs_to(:mg_student)
end
