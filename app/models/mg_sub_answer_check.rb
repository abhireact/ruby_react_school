class MgSubAnswerCheck < ApplicationRecord
  belongs_to(:mg_student_exam_check_detail)
  belongs_to(:mg_sub_question_bank)
  belongs_to(:mg_school)
end
