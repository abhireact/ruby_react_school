class MgLibraryEmployee < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_employee)
end
