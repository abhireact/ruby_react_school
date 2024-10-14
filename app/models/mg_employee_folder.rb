class MgEmployeeFolder < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_employee)
  has_many :mg_document_managements,  dependent: :destroy 
  belongs_to(:mg_batch_subject)
end
