class MgAppFaqCategory < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_app_faq_qas,  dependent: :destroy 
  has_many :mg_app_faq_sub_categories,  dependent: :destroy 

  def self.search(search)
    if search
      self.where("name like ?", "%#{search}%")
    else
      self.all
    end
  end
end
