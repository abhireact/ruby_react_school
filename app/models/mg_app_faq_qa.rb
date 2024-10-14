class MgAppFaqQa < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_app_faq_category)
  belongs_to(:mg_app_faq_sub_category)

  def self.search(search)
  end
end
