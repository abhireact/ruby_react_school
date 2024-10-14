class MgSubQuestionBank < ApplicationRecord
  belongs_to(:mg_question_bank)
  belongs_to(:mg_school)
  has_many :mg_question_details,  dependent: :destroy 
  has_many :mg_student_sub_answers,  dependent: :destroy 
  accepts_nested_attributes_for(:mg_question_details, { reject_if: :all_blank, allow_destroy: true })
  validates_presence_of(:question_name, { message: "Question Shouldnot Be Empty" })
end
