class MgQuestionSet < ApplicationRecord
  belongs_to(:mg_create_question_paper)
  belongs_to(:mg_school)
  has_many :mg_student_appear_exams,  dependent: :destroy 
  has_many :mg_question_set_details,  dependent: :destroy 
  has_many :mg_question_banks,  through: :mg_question_set_details, dependent: :destroy 
end
