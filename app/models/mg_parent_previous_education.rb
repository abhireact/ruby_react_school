class MgParentPreviousEducation < ApplicationRecord
  belongs_to(:mg_student_admission)
  belongs_to(:mg_school)
end
