class MgGradingLevel < ApplicationRecord
  # belongs_to(:mg_batch)
  # belongs_to(:mg_school)
  has_many :mg_exams,  dependent: :destroy 
  has_many :mg_exam_scores,  dependent: :destroy 
end
