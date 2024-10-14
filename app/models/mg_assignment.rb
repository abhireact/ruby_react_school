class MgAssignment < ApplicationRecord
  belongs_to(:mg_batch)
  belongs_to(:mg_school)
  belongs_to(:mg_subject)
  belongs_to(:mg_homework_category)
  has_many :mg_assignment_documentations,  dependent: :destroy 
  has_many :mg_students,  through: :mg_assignment_documentations, dependent: :destroy 
  has_many :mg_employees,  dependent: :destroy 
  has_many :mg_assignment_submissions,  dependent: :destroy 
  has_many :mg_students,  through: :mg_assignment_submissions, dependent: :destroy 
end
