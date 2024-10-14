class MgSportsResult < ApplicationRecord
  belongs_to(:mg_event)
  belongs_to(:mg_school)
  belongs_to(:mg_sport_game)
  belongs_to(:mg_event_committee)
  has_many :mg_sport_employee_data_results,  dependent: :destroy 
  has_many :mg_employees,  through: :mg_sport_employee_data_results, dependent: :destroy 
  has_many :mg_sport_student_data_results,  dependent: :destroy 
  has_many :mg_students,  through: :mg_sport_student_data_results, dependent: :destroy 
end
