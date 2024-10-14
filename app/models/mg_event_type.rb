class MgEventType < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_events,  dependent: :destroy 
end
