class MgAlumni < ApplicationRecord
  has_many :mg_alumni_photo_galleries,  dependent: :destroy 
  belongs_to(:mg_school)
  belongs_to(:mg_alumni_programme_attended)
  has_many :mg_get_togethers,  dependent: :destroy 
  has_many :mg_alumni_get_togethers,  through: :mg_get_togethers, dependent: :destroy 
  has_many :mg_payment_gateways,  dependent: :destroy 
  has_many :mg_master_payment_types,  through: :mg_payment_gateways, dependent: :destroy 
  has_many :mg_users,  through: :mg_alumni_photo_galleries, dependent: :destroy 
end
