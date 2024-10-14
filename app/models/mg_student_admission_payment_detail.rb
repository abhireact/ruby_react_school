class MgStudentAdmissionPaymentDetail < ApplicationRecord
  belongs_to(:mg_student_admission_request)
end
