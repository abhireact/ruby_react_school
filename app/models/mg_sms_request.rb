class MgSmsRequest < ApplicationRecord
  has_many :mg_sms_details,  dependent: :destroy 
end
