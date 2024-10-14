class MgSportTeamEmployee < ApplicationRecord
  belongs_to(:mg_employee)
  belongs_to(:mg_school)
  belongs_to(:mg_sport_team)
end
