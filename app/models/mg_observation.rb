class MgObservation < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_observation_group)
end
