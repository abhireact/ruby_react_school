module MgEmployeesHelper

    def get_employee_category_employee
		MgEmployeeCategory.where(:is_deleted=>0)
	end
	def get_employee_category
		MgEmployeeCategory.where(:is_deleted=>0).pluck(:category_name,:id)
	end

	def get_employee_type  
		MgEmployeeType.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:employee_type,:id)
	end

	def get_employee_grade
		MgEmployeeGrade.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).pluck(:grade_name,:id)
	end

	def get_employee_position
		MgEmployeePosition.where(:is_deleted=>0,:mg_school_id=>[:current_user_school_id])
		# MgEmployeePosition.all
	end
    # for dependancy Added By Deepak Starts
    
	
	def get_dependent_models(table_name)
		link_name = Array.new
		if table_name.to_s == "mg_committee_members"
			link_name[0] = "event_committees/add_committee_members"
			link_name[1] = "Committee Members"
		# elsif  table_name.to_s == "mg_finance_officers"
		elsif  table_name.to_s == "mg_hostel_wardens"
			link_name[0] = "hostel_management/hostel_warden_login_index"
			link_name[1] = "Hostel Warden"
		# elsif  table_name.to_s == "mg_inventory_store_managers"
		# elsif  table_name.to_s == "mg_sport_team_employees"
		# elsif  table_name.to_s == "mg_time_table_change_entries"
			# link_name = "timetable"
		elsif  table_name.to_s == "mg_time_table_entries"
			link_name[0] = "timetable"
			link_name[1] = "Time Table Association"
		# elsif  table_name.to_s == "mg_topics"
		elsif  table_name.to_s == "mg_transports"
			link_name[0] = "transports/index"
			link_name[1] = "Route Management
			"
		elsif  table_name.to_s == "mg_syllabus_trackers"
		link_name[0] = ""
		link_name[2] = "Ask Employee need to change the syllabus"
		# elsif  table_name.to_s == "mg_units"
		# elsif  table_name.to_s == "mg_vehicles"
		end
		return link_name
	end
    # for dependancy Added By Deepak Ends
end
