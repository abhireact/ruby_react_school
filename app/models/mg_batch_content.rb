class MgBatchContent < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_batch)
  belongs_to(:mg_employee)
  has_many :mg_my_questions,  dependent: :destroy 
end
