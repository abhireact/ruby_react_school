class MgFaCriteria < ApplicationRecord
  belongs_to(:mg_fa_group)
  has_many :mg_descriptive_indicators,  dependent: :destroy 
end
