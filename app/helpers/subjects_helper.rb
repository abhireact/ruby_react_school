module SubjectsHelper
	def get_dependent_models_for_subject(table_name)
		link_name = Array.new
		if table_name.to_s == "mg_batch_subjects"
			link_name[0] = "subjects/batch_subject_asso"
			link_name[1] = "Section Subject Association"
		elsif  table_name.to_s == "mg_employee_subjects"
			link_name[0] = "subjects/emp_subject_asso"
			link_name[1] = "Employee Subject Association"
		elsif  table_name.to_s == "mg_time_table_entries"
			link_name[0] = "timetable"
			link_name[1] = "Time Table Association"
		elsif  table_name.to_s == "mg_transports"
			link_name[0] = "transports/index"
			link_name[1] = "Route Management"
		end
		return link_name
	end
end
