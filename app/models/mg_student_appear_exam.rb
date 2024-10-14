class MgStudentAppearExam < ApplicationRecord
  belongs_to(:mg_question_set)
  belongs_to(:mg_student)
  belongs_to(:mg_school)
  has_many :mg_student_exam_details,  dependent: :destroy 

  def self.get_appear_data(set_id, student, school_id)
    appear_data = self.find_by({ is_deleted: 0, mg_school_id: school_id, mg_student_id: student, mg_question_set_id: set_id })
    appear_data
  end
end
