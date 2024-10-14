class MgCertificateTracking < ApplicationRecord
  def self.certificate_track(employee_id, student_id, certificate_type, mg_school_id, user_id)
    if employee_id != ""
      certificate = MgCertificateTracking.find_by({ mg_employee_id: employee_id, certificate_type:, is_deleted: 0 })
    end
    if student_id != ""
      certificate = MgCertificateTracking.find_by({ mg_student_id: student_id, certificate_type:, is_deleted: 0 })
    end
    if certificate.nil?
      count = 1
      certificate_tracking = MgCertificateTracking.new
      if employee_id != ""
        certificate_tracking.mg_employee_id=employee_id
      end
      if student_id != ""
        certificate_tracking.mg_student_id=student_id
      end
      certificate_tracking.mg_school_id=mg_school_id
      certificate_tracking.certificate_type=certificate_type
      certificate_tracking.issued_times=count
      certificate_tracking.is_deleted=0
      certificate_tracking.date_of_issue=Date.today.strftime("%d/%m/%Y")
      certificate_tracking.created_by=user_id
      certificate_tracking.updated_by=user_id
      certificate_tracking.save
    else
      count1 = certificate.issued_times + 1
      certificate.update({ issued_times: count1 })
    end
  end
end
