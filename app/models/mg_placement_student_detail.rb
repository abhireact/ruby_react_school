class MgPlacementStudentDetail < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:student)
end
