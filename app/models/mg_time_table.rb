class MgTimeTable < ApplicationRecord
  validates(:start_date, :end_date, { overlap: { scope: "mg_school_id", query_options: { active: nil } } })
  scope(:active, lambda {
    where({ is_deleted: false })
  })
  belongs_to(:mg_school)
  has_many :mg_booster_dose_details,  dependent: :destroy 
  has_many :mg_vaccination_details,  dependent: :destroy 
  has_many :mg_courses,  dependent: :destroy 
  has_many :mg_fee_registrations,  dependent: :destroy 
end
