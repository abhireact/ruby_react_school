class MgCbscCoSchoParticularClassAssoc < ApplicationRecord
  belongs_to(:mg_course)
  belongs_to(:mg_batch)
end
