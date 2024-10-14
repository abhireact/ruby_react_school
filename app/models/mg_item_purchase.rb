class MgItemPurchase < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_lab)
  belongs_to(:mg_laboratory_subject)
end
