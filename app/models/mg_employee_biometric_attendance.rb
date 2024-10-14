class MgEmployeeBiometricAttendance < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_employee)
  validates(:check_in, :check_out, { overlap: { scope: ["mg_school_id", "date", "mg_employee_id"], query_options: { active: nil } } })
  scope(:active, lambda {
    where({ is_deleted: false })
  })
end
