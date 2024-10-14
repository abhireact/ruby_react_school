# class MgCheckUpSchedule < ApplicationRecord
#   belongs_to(:mg_school)
#   has_many :mg_check_up_schedule_records,  dependent: :destroy 
#   has_many :mg_baches,  through: :mg_check_up_schedule_records, dependent: :destroy 
#   has_many :mg_employees,  through: :mg_health_tests, dependent: :destroy 
#   has_many :mg_health_tests,  dependent: :destroy 
#   has_many :mg_students,  through: :mg_health_tests, dependent: :destroy 

#   def self.myprm(date)
#     @date = date
#   end
#   validates(:start_time, :end_time, { overlap: { scope: ["mg_doctor_id", "mg_school_id"], query_options: { active: nil, date_validation: nil } } })
#   scope(:active, lambda {
#     where({ is_deleted: false })
#   })
#   scope(:date_validation, lambda {
#     where("`mg_check_up_schedules`.`date` <= ? AND `mg_check_up_schedules`.`date` >= ?", "#{@date}", "#{@date}")
#   })
# end

class MgCheckUpSchedule < ApplicationRecord
  belongs_to :mg_school
  has_many :mg_check_up_schedule_records, dependent: :destroy 
  has_many :mg_batches, through: :mg_check_up_schedule_records, dependent: :destroy 
  has_many :mg_employees, through: :mg_health_tests, dependent: :destroy 
  has_many :mg_health_tests, dependent: :destroy 
  has_many :mg_students, through: :mg_health_tests, dependent: :destroy 

  validates :start_time, :end_time, presence: true
  validates_with OverlapValidator

  scope :active, -> { where(is_deleted: false) }
  scope :date_validation, ->(date) { where("mg_check_up_schedules.date <= ? AND mg_check_up_schedules.date >= ?", date, date) }
end
