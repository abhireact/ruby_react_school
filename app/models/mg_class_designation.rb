class MgClassDesignation < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_course)
end