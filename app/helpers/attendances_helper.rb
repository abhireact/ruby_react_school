module AttendancesHelper
	# def get_employee_category
	# 	MgEmployeeCategory.where(:is_deleted=>0)
	# end
	def get_holiday_by_emp_category(mg_employee_category_id)
		holiday_list = ""
		if mg_employee_category_id != ""
		   holiday_list = MgHoliday.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_category_id=>mg_employee_category_id).pluck(:holiday_name,:id)
		else
           holiday_list = MgHoliday.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:applicable_for=> "All").pluck(:holiday_name,:id)
		end
		return holiday_list
	end
end
