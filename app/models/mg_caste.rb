class MgCaste < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_students,  dependent: :destroy 
  validates(:name, { uniqueness: { scope: :mg_school_id, case_sensitive: false, conditions: lambda {
    where({ is_deleted: false })
  } } })
end
