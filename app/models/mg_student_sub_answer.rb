class MgStudentSubAnswer < ApplicationRecord
  belongs_to(:mg_student_exam_detail)
  belongs_to(:mg_sub_question_bank)
  belongs_to(:mg_question_detail)
  belongs_to(:mg_school)

  def self.get_student_answer(check_for_sub_ans, school)
    ans_data = self.where({ mg_student_exam_detail_id: check_for_sub_ans, is_deleted: 0, mg_school_id: school })
    ans_data
  end
end
