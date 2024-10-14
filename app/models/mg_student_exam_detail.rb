class MgStudentExamDetail < ApplicationRecord
  belongs_to(:mg_student_appear_exam)
  belongs_to(:mg_question_bank)
  belongs_to(:mg_school)
  has_many :mg_student_sub_answers,  dependent: :destroy 

  def self.get_examDetails(all_answer_parent, school_id)
    answer_detail = self.where({ mg_student_appear_exam_id: all_answer_parent.id, is_deleted: 0, mg_school_id: school_id })
    answer_detail
  end
end
