class MgBatchDocument < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_document_management)
  belongs_to(:mg_batch)
  belongs_to(:mg_employee)
end
