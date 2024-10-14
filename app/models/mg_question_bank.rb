class MgQuestionBank < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_batch)
  belongs_to(:mg_syllabus)
  belongs_to(:mg_topic)
  belongs_to(:mg_unit)
  belongs_to(:mg_online_question_type)
  has_many :mg_question_details,  dependent: :destroy 
  accepts_nested_attributes_for(:mg_question_details, { reject_if: :all_blank, allow_destroy: true })
  has_many :mg_sub_question_banks,  dependent: :destroy 
  accepts_nested_attributes_for(:mg_sub_question_banks, { reject_if: :all_blank, allow_destroy: true })
  has_many :mg_question_set_details,  dependent: :destroy 
  has_many :mg_question_sets,  through: :mg_question_set_details, dependent: :destroy 
  validates_presence_of(:mark, { message: "Mark Shouldnot Be Empty" })

  def self.getQuestionBank(questions, school)
    banks = self.where({ id: questions, is_deleted: 0, mg_school_id: school }).order("field(id, #{questions.join(",")})")
    count = banks.count
    banks
  end

  def self.chachedQuestionsFromSet(set_id, questions, school)
    puts("chachedQuestionsFromSet" + set_id.to_s)
    Rails.cache.fetch(["questions_from_ids", questions], { expires_in: 180.minutes }) {
      self.where({ id: questions, is_deleted: 0, mg_school_id: school }).order("field(id, #{questions.join(",")})").load
    }
  end
end
