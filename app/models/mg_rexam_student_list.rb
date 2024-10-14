class MgRexamStudentList < ApplicationRecord
  belongs_to(:mg_student)
  belongs_to(:mg_subject)
  belongs_to(:mg_school)
  belongs_to(:mg_create_question_paper)
end
