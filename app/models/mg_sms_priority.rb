class MgSmsPriority < ApplicationRecord
  belongs_to(:mg_sms_configeration)
  belongs_to(:mg_school)
end
