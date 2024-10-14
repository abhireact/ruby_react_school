class MgBooksTransaction < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_books_inventory)
  belongs_to(:mg_student)
  belongs_to(:mg_employee)
  belongs_to(:mg_resource_inventory)
end
