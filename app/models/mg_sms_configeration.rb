class MgSmsConfigeration < ApplicationRecord
  has_many :mg_sms_addion_attribute,  dependent: :destroy 
  has_many :mg_sms_priorities,  dependent: :destroy 
end
