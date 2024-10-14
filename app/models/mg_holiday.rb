class MgHoliday < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_employee_category)
  has_many :mg_employee_holiday_attendances,  dependent: :destroy 
  has_many :mg_employees,  through: :mg_employee_holiday_attendances, dependent: :destroy 
  validates(:holiday_start_date, :holiday_end_date, { overlap: { scope: "mg_school_id", query_options: { active: nil } } })
  scope(:active, lambda {
    where({ is_deleted: false })
  })
end
