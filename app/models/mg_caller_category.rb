class MgCallerCategory < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_query_records,  dependent: :destroy 
end
