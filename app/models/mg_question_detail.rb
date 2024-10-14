class MgQuestionDetail < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_question_bank)
  belongs_to(:mg_sub_question_bank)
  has_many :mg_student_sub_answers,  dependent: :destroy 
  validate(:has_a_option)
  validates_presence_of(:name, { message: "Option shouldnot be Empty" })

  def self.getoptionbybank(question, school_id)
    options = self.where({ mg_question_bank_id: question, is_deleted: 0, mg_school_id: school_id })
    options
  end

  def self.getoptionbySubank(sub_question, school_id)
    sub_options = self.where({ mg_sub_question_bank_id: sub_question, is_deleted: 0, mg_school_id: school_id })
    sub_options
  end
  private

  def has_a_is_answer
  end

  def has_a_option
    if self.name.empty?
      errors.add(:base, "Two option should be required")
    end
  end
end
