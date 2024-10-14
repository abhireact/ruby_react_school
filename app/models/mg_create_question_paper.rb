class MgCreateQuestionPaper < ApplicationRecord
  belongs_to(:mg_course)
  belongs_to(:mg_batch)
  belongs_to(:mg_subject)
  belongs_to(:mg_school)
  has_many :mg_student_exam_checks,  dependent: :destroy 
  has_many :mg_question_sets,  dependent: :destroy 
  has_many :mg_rexam_student_lists,  dependent: :destroy 
  has_many :mg_ques_chapter_weightages,  dependent: :destroy 
  accepts_nested_attributes_for(:mg_ques_chapter_weightages, { reject_if: :all_blank, allow_destroy: true })
  has_many :mg_section_mark_details,  dependent: :destroy 
  accepts_nested_attributes_for(:mg_section_mark_details, { reject_if: :all_blank, allow_destroy: true })
end
