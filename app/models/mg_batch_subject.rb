class MgBatchSubject < ApplicationRecord
  belongs_to(:mg_batch)
  belongs_to(:mg_subject)
  belongs_to(:mg_school)
  has_many :mg_employee_folders,  dependent: :destroy 
end
