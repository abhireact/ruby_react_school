class MgExam < ApplicationRecord
  belongs_to(:mg_exam_group)
  belongs_to(:mg_subject)
  belongs_to(:mg_grading_level)
  belongs_to(:mg_event)
  belongs_to(:mg_school)
  belongs_to(:mg_batch)
  has_many :mg_assessment_scores,  dependent: :destroy 
  has_many :ms_students,  through: :mg_assessment_scores, dependent: :destroy 
  has_many :mg_exam_scores,  dependent: :destroy 
end
