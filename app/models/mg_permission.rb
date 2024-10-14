class MgPermission < ApplicationRecord
  has_many :mg_roles_permissions,  dependent: :destroy 
  has_many :mg_roles,  through: :mg_roles_permissions, dependent: :destroy 
end
