class MgSportTeamStudent < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_sport_team)
  belongs_to(:mg_student)
end
