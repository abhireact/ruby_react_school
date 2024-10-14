class MgQueryRecord < ApplicationRecord
  belongs_to(:mg_caller_category)
  belongs_to(:mg_caller_category_fom)
  belongs_to(:mg_fom_query_record)
  belongs_to(:mg_school)
end
