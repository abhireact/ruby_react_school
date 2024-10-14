class MgLanguage < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_user)
end
