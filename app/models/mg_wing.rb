class MgWing < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_resource_categories,  dependent: :destroy 
  has_many :mg_allocate_rooms,  dependent: :destroy 
  has_many :mg_alumni_get_togethers,  dependent: :destroy 
  has_many :mg_alumni_programme_attendeds,  dependent: :destroy 
  has_many :mg_class_timings,  dependent: :destroy 
  has_many :mg_courses,  dependent: :destroy 
  has_many :mg_disciplinary_actions,  dependent: :destroy 
  has_many :mg_hostel_attendances,  dependent: :destroy 
  has_many :mg_hostel_reallotment_requests,  dependent: :destroy 
  has_many :mg_invitations,  dependent: :destroy 
  has_many :mg_invite_get_togethers,  dependent: :destroy 
  has_many :mg_payment_gateways,  dependent: :destroy 
  has_many :mg_subjects,  dependent: :destroy 
  has_many :mg_syllabus_trackers,  dependent: :destroy 
  has_many :mg_topics,  dependent: :destroy 
  has_many :mg_units,  dependent: :destroy 
  has_many :mg_weekdays,  dependent: :destroy 
  has_many :mg_attendance_settings,  dependent: :destroy 
  validates(:wing_name, { uniqueness: { scope: :mg_school_id, case_sensitive: false, conditions: lambda {
    where({ is_deleted: false })
  } } })

  def self.get_wing_by_id(id)
    MgWing.find(id)
  end
end
