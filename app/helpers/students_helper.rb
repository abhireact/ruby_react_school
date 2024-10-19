module StudentsHelper
	def caste
	 MgCaste.where( is_deleted: 0,mg_school_id: session[:current_user_school_id] ).pluck(:name,:id)
	end

	def get_caste_category
		MgCasteCategory.where( is_deleted: 0,mg_school_id: session[:current_user_school_id])
	end
	def get_student_category
		MgStudentCategory.where( is_deleted: 0,mg_school_id: session[:current_user_school_id] )
	end
	def get_house_details
		MgHouseDetails.where( is_deleted: 0,mg_school_id: session[:current_user_school_id] )
	end

	def get_caste
		 MgCaste.where( is_deleted: 0,mg_school_id: session[:current_user_school_id] )
	end
	def get_dependent_student_models(table_name,id)
		link_name = Array.new
		if table_name.to_s == "mg_committee_members"
			link_name[0] = "event_committees/add_committee_members"
			link_name[1] = "Committee Members"
		elsif  table_name.to_s == "mg_student_guardians"
			link_name[0] = "guardians/student_guardian_show/"+id.to_s
			link_name[0] = "guardians"
			link_name[1] = "Guardians_show"
		end
		return link_name
	end
end
