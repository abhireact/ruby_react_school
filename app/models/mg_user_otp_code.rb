class MgUserOtpCode < ApplicationRecord
  belongs_to :mg_user
  has_one_time_password length: 4, secret_key: :my_otp_secret_column
end
