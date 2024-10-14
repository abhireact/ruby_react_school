class MgRankingLevels < ApplicationRecord
  belongs_to(:mg_course)
  belongs_to(:mg_school)
end
