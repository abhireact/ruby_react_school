module ClassesHelper
	def get_dependent_models_for_class(table_name)
		link_name = Array.new
		if table_name.to_s == "mg_students"
			link_name[0] = "/students"
			link_name[1] = "Student List"
		elsif  table_name.to_s == "mg_subjects"
			link_name[0] = "/subjects"
			link_name[1] = "Subject"
		elsif  table_name.to_s == "mg_batches"
			link_name[0] = "/classes"
			link_name[1] = "Section"
		elsif  table_name.to_s == "mg_cbsc_exam_type_associations"
			link_name[0] = "/master_settings"
			link_name[1] = "Examinations"
		elsif  table_name.to_s == "mg_student_admissions"
			link_name[0] = "/mg_student_admissions"
			link_name[1] = "Admission"
		end
		return link_name
	end
end
