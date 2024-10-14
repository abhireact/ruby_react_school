class BlacklistedToken < ApplicationRecord
  belongs_to(:mg_user)
end
