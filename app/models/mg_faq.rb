class MgFaq < ApplicationRecord
  belongs_to(:mg_school)

  def self.search(search)
    arr = Array.new
    arr.push(search)
    search_value = ""
    if search
      if arr.size > 0
        for i in 0..arr.size - 1 do
          search_value += " question LIKE '%#{arr.[](i)}%' or answer LIKE '%#{arr.[](i)}%' "
          search_value += " or mg_faq_category_id IN (select id from mg_faq_categories where category_name LIKE '%#{arr.[](i)}%') "
          search_value += " or mg_faq_sub_category_id IN (select id from mg_faq_sub_categories where sub_category_name LIKE '%#{arr.[](i)}%') "
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
