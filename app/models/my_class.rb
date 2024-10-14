class MyClass
  def self.wing_dependancy(column, id)
    @valuesOfDependancy = Array.new
    @presence = Array.new
    @wingArr = ["mg_allocate_rooms", "mg_alumni_get_togethers", "mg_alumni_programme_attendeds", "mg_class_timings", "mg_courses", "mg_disciplinary_actions", "mg_hostel_attendances", "mg_hostel_reallotment_requests", "mg_invitations", "mg_invite_get_togethers", "mg_payment_gateways", "mg_weekdays"]
    @wingArr.each { |table,|
      @presence = ActiveRecord::Base.connection.execute("select * from #{table} where #{column} = #{id}")
      puts(@presence.inspect)
      @presence.to_a
      @presence.each({ as: :array }) { |row,|
        @valuesOfDependancy.push(row.[](0))
      }
      if @valuesOfDependancy.present?
        return true
      end
    }
    false
  end
end
