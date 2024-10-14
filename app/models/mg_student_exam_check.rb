class MgStudentExamCheck < ApplicationRecord
  belongs_to(:mg_student)
  belongs_to(:mg_create_question_paper)
  belongs_to(:mg_question_set)
  belongs_to(:mg_school)
  has_many :mg_student_exam_check_details,  dependent: :destroy 
end
