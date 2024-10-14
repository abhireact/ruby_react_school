class MgAdmissionPaymentDetail < ApplicationRecord
  belongs_to(:mg_student_admission)
  belongs_to(:mg_school)
  store(:json_data, { coder: JSON })
end
