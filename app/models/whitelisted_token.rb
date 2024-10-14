class WhitelistedToken < ApplicationRecord
  belongs_to(:mg_user)
end
