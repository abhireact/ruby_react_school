class MgAppFaqSubCategory < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_app_faq_category)
  has_many :mg_app_faq_qas,  dependent: :destroy 
end
