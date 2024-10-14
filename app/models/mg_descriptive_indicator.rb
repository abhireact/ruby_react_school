class MgDescriptiveIndicator < ApplicationRecord
  belongs_to(:mg_fa_criteria)
  belongs_to(:mg_school)
  has_many :mg_assessment_scores,  dependent: :destroy 
end
