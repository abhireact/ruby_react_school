class MgSportGame < ApplicationRecord
  validates(:name, { uniqueness: { scope: :mg_school_id, conditions: lambda {
    where({ is_deleted: false })
  } } })
  has_many :mg_sport_teams,  dependent: :destroy 
  has_many :mg_sports_results,  dependent: :destroy 
  belongs_to(:mg_school)
end
