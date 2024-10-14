class MgBoosterDose < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_booster_dose_details,  dependent: :destroy 
  has_many :mg_students,  through: :mg_booster_dose_details, dependent: :destroy 
  has_many :mg_batches,  through: :mg_booster_dose_details, dependent: :destroy 
  validates(:name, { uniqueness: { scope: :mg_school_id, conditions: lambda {
    where({ is_deleted: false })
  } } })
end
