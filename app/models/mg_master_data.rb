class MgMasterData < ApplicationRecord
  validates(:mg_state_id, :mg_school_id, :mg_agent_id, :go_live_date, :billing_start_date, :mg_financial_year_id, { presence: true, length: { maximum: 50 } })
  belongs_to(:mg_school)
  belongs_to(:mg_agent)
  belongs_to(:mg_financial_year)
  belongs_to(:mg_state)

  def self.get_school_amount(school_id, financial_year_id, payment_type, payment_schedule_child)
    amount_arr = []
    master_data = self.find_by({ mg_school_id: school_id, mg_financial_year_id: financial_year_id, is_deleted: 0 })
    payment_schedule = MgPaymentScheduleChild.find_by({ id: payment_schedule_child, is_deleted: 0 })
    start_date = payment_schedule.start_date.to_date
    end_date = payment_schedule.end_date.to_date
    months = (start_date..end_date).map { |m,|
      m.strftime("%Y%m")
    }.uniq.map { |m,|
      "#{Date::ABBR_MONTHNAMES.[](Date.strptime(m, "%Y%m").mon)}-#{Date.strptime(m, "%Y%m").year}"
    }
    case payment_type
    when "Constant"
      amount = master_data.constant_amount.to_f
    when "Variable"
      per_student_rate = master_data.rate_per_student.to_f
      total_students = 0
      months.each { |month,|
        end_date = month.to_date.end_of_month
        students_count = MgStudent.where({ mg_school_id: school_id, is_deleted: 0, is_archive: 0 }).where("created_at <= ?", end_date).count
        total_students += students_count
      }
      amount = total_students * per_student_rate
      amount_arr << amount
      amount_arr << total_students
      amount_arr << per_student_rate
    end
    amount_arr
  end

  def self.get_student_amount(school_id, financial_year_id, payment_schedule_child, pre_invoice_gen_date)
    amount_arr = []
    master_data = self.find_by({ mg_school_id: school_id, mg_financial_year_id: financial_year_id, is_deleted: 0 })
    payment_schedule = MgPaymentScheduleChild.find_by({ id: payment_schedule_child, is_deleted: 0 })
    start_date = payment_schedule.start_date.to_date
    end_date = payment_schedule.end_date.to_date
    months = (start_date..end_date).map { |m,|
      m.strftime("%Y%m")
    }.uniq.map { |m,|
      "#{Date::ABBR_MONTHNAMES.[](Date.strptime(m, "%Y%m").mon)}-#{Date.strptime(m, "%Y%m").year}"
    }
    count = MgStudent.where({ mg_school_id: school_id, is_deleted: 0, is_archive: 0 }).where("created_at <= ?", pre_invoice_gen_date.to_date.end_of_month).count
    per_student_rate = master_data.rate_per_student.to_f
    total_students = 0
    count_array = []
    months.each { |month,|
      end_date = month.to_date.end_of_month
      students_count = MgStudent.where({ mg_school_id: school_id, is_deleted: 0, is_archive: 0 }).where("created_at <= ?", end_date).count
      total_students += students_count
      count_hash = Hash.new
      if students_count != count
        count_hash.[]=(:month_name, month)
        count_hash.[]=(:count, students_count - count)
        count_array << count_hash
      end
    }
    amount_arr << total_students
    amount_arr << per_student_rate
    amount_arr << count_array
    amount_arr
  end
end
