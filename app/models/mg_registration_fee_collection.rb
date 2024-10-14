class MgRegistrationFeeCollection < ApplicationRecord
  belongs_to(:mg_fee_registration, lambda {
    where({ is_deleted: 0 })
  })
  validates_presence_of(:student_name, :mg_fee_registration_id, :mg_course_id)
end
