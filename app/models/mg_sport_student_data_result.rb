class MgSportStudentDataResult < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_student)
  belongs_to(:mg_sports_result)
end
