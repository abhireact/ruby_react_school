class MgPollOptionAlumni < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_poll_option_alumni_particulars,  dependent: :destroy 
end
