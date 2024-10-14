class MgCheckupParticular < ApplicationRecord
  belongs_to(:mg_checkup_type)
  belongs_to(:mg_school)
  has_many :mg_health_tests,  dependent: :destroy 
end
