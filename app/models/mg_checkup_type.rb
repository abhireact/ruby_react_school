class MgCheckupType < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_checkup_particulars,  dependent: :destroy 
  validates(:name, { uniqueness: { scope: :mg_school_id, conditions: lambda {
    where({ is_deleted: false })
  } } })
end
