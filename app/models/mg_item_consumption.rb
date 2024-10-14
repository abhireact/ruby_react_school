class MgItemConsumption < ApplicationRecord
  belongs_to(:mg_batch)
  belongs_to(:mg_school)
  belongs_to(:mg_lab)
  belongs_to(:mg_course)
  belongs_to(:mg_laboratory_subject)
  has_one :mg_student_item_consumptions,  dependent: :destroy 
  belongs_to(:student)

  def self.search(search)
    arr = Array.new
    issueDate = 0
    arr.push(search)
    if search.present?
      issueDate = search.split("/").reverse.join("-")
    end
    @date = Array.new
    search_value = ""
    if search
      if arr.size > 0
        for i in 0..arr.size - 1 do
          search_value += " consumption_type LIKE '%#{arr.[](i)}%' or date LIKE '%#{issueDate}%' or mg_lab_id IN (select id from mg_labs where lab_name LIKE '%#{arr.[](i)}%')"
          search_value += " or mg_category_id IN (select id from mg_lab_inventories where category_name LIKE '%#{arr.[](i)}%') "
          search_value += " or mg_item_id IN (select id from mg_inventory_managements where item_name LIKE '%#{arr.[](i)}%') "
          if i < arr.size.-(1)
            search_value += " or "
          end
        end
      end
      where(search_value)
    else
      all
    end
  end
end
