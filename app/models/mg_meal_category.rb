class MgMealCategory < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_canteen_meals,  dependent: :destroy 
  validates(:priority, { uniqueness: { scope: :mg_school_id, conditions: lambda {
    where({ is_deleted: false })
  } } })
end
