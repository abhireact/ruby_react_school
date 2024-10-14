class MgFomQueryRecord < ApplicationRecord
  has_many :mg_query_records,  dependent: :destroy 
  belongs_to(:mg_school)
end
