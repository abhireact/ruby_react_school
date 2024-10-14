class MgAddressBookFom < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_designation_fom)
end
