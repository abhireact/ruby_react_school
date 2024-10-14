class MgStudentExamCheckDetail < ApplicationRecord
  belongs_to(:mg_student_exam_check)
  belongs_to(:mg_question_bank)
  belongs_to(:mg_school)
  has_many :mg_sub_answer_checks,  dependent: :destroy 
end
