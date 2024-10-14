class MgSportTeam < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_sport_game)
  has_many :mg_sport_team_employees,  dependent: :destroy 
  has_many :mg_sport_team_students,  dependent: :destroy 
  has_many :mg_students,  through: :mg_sport_team_students, dependent: :destroy 
  has_many :mg_employees,  through: :mg_sport_team_employees, dependent: :destroy 
  validates(:team_name, { uniqueness: { scope: :mg_school_id, conditions: lambda {
    where({ is_deleted: false })
  } } })
end
