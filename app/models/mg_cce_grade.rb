class MgCceGrade < ApplicationRecord
  belongs_to(:mg_cce_grades_set)
  belongs_to(:mg_school)
end
