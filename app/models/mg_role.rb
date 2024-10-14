class MgRole < ApplicationRecord
  has_many :mg_roles_permissions,  dependent: :destroy 
  has_many :mg_permissions,  through: :mg_roles_permissions, dependent: :destroy 
  belongs_to(:mg_school)
  has_many :mg_user_roles,  dependent: :destroy 
  validates(:role_name, { uniqueness: { conditions: lambda {
    where({ mg_school_id: nil })
  } } })
  validates(:role_name, { uniqueness: { scope: :mg_school_id } })
end
