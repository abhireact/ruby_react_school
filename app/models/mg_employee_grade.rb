class MgEmployeeGrade < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_employees,  dependent: :destroy 
  has_many :mg_grade_components,  dependent: :destroy 
  has_and_belongs_to_many(:mg_salary_components)
end
