class MgExpenseEntry < ApplicationRecord
  mount_uploader(:bill_file, DocumentUploader)
  belongs_to(:mg_expense_head)
  belongs_to(:mg_expense_item)
  belongs_to(:mg_school)
end
