#version 1.0 for employee apply leave option 3/07/2028 
#version 1.1 for employee experience leave option 17/07/2028  by bindhu
#version 1.2 for deducting leave option 03/08/2028  by Mamtha
#version 1.3 for defects deducting leave option 08/08/2028  by Mamtha
#version 1.4 for leave type accumulation means accumulation count will be added in leave type else max count of leaves  10/08/2028  by Mamtha
#version 1.5(14/08/18 for employee attendance modification by mamatha)
#version 1.6(21/08/18 for employee attendance modification by mamatha)
class MgEmployeeLeaveTypesController < ApplicationController
#com
	layout "mindcom"
	# before_filter :login_required
	
		def new 
			@mg_employee_leave_types=MgEmployeeLeaveType.new()
			# render :layout => false
		end
	
		def index
	
		  	@mg_employee_leave_types = MgEmployeeLeaveType.where(:is_deleted => 0,:mg_school_id=>session[:current_user_school_id])
			@react_data={mg_employee_leave_types:@mg_employee_leave_types}
			if params[:api_request].present?
			 render json: @mg_employee_leave_types, status: :created
			end
		 
		end

		def create
			mg_school_id=session[:current_user_school_id]
			school=MgSchool.find(mg_school_id)
		  	@mg_employee_leave_types=MgEmployeeLeaveType.new(employees_params)
		 	@mg_employee_leave_types.minimum_month_experience=params[:mg_employee_leave_types][:minimum_year_experience].to_i*12+@mg_employee_leave_types.minimum_month_experience
		 	months_array = ((school.mg_leave_calendar_start_date)..school.mg_leave_calendar_start_date.next_year-1.month).map{|d| [d.month,d.year]}.uniq
		 	
		  	if @mg_employee_leave_types.save
		  		if params[:mg_employee_leave_types][:reset_date].present?
		 			@mg_employee_leave_types.reset_date=Date.strptime(params[:mg_employee_leave_types][:reset_date],school.date_format)
		  		end
		  		query_str  = "is_deleted = 0 AND mg_school_id = ? AND experience_year*12 + experience_month +TIMESTAMPDIFF(MONTH, joining_date, CURDATE())>= ? AND mg_employee_type_id = ? "
		  		if @mg_employee_leave_types.gender!="all"
				     query_str = query_str + " AND gender = '#{@mg_employee_leave_types.gender}'"
		  		end
		  		# for leave month year

		  		this_month=Date.today#.ago(1.month)
			    start_from=this_month.beginning_of_month
			    month_start=start_from.strftime('%Y-%m-%d')

		  		@employees=MgEmployee.where(query_str,session[:current_user_school_id],@mg_employee_leave_types.minimum_month_experience,@mg_employee_leave_types.mg_employee_type_id)	
		  		@employees.each do |employee|
		  			leave_assignment(employee,school,@mg_employee_leave_types)
			  	end
		  				
		    	redirect_to :action=>'index'
		  	 else
		     redirect_to :back
		  	end
		end

		def leave_assignment(employee,school,mg_employee_leave_types)

			months_array = ((school.mg_leave_calendar_start_date)..school.mg_leave_calendar_start_date.next_year-1.month).map{|d| [d.month,d.year]}.uniq
			i = 1
		  			months_array.each do |leave_month|
		  				date_for_month =Date.new(leave_month[1].to_i,leave_month[0].to_i,1)
		  				date_for_month=date_for_month.strftime('%Y-%m-%d')

		  				# leave_record = MgEmployeeLeaves.find_by(:mg_employee_id=>employee.id,:leave_month_year=>date_for_month)

			  			employee_leaves=MgEmployeeLeaves.new
			            employee_leaves.mg_employee_id=employee.id
			            employee_leaves.mg_leave_type_id=mg_employee_leave_types.id
			            employee_leaves.leave_taken=0
			            employee_leaves.mg_school_id=session[:current_user_school_id]
			            employee_leaves.is_deleted=0
			             if  mg_employee_leave_types.is_accumilation
			                employee_leaves.available_leave=(mg_employee_leave_types.accumilation_count.to_f * i).ceil
			                i+= 1
			             else
			                employee_leaves.available_leave=mg_employee_leave_types.max_leave_count
			             end
			            employee_leaves.leave_month_year=date_for_month
			            employee_leaves.save
			  		end
		end

		def show
			@school=MgSchool.find(session[:current_user_school_id])
		  	@mg_employee_leave_types = MgEmployeeLeaveType.find(params[:id])
		  	# render :layout => false  	
		end

	  	def edit
	  	mg_school_id=session[:current_user_school_id]
		@school=MgSchool.find(mg_school_id)
	 	@mg_employee_leave_types = MgEmployeeLeaveType.find(params[:id])
	 	# render :layout => false

		end

		def update
		mg_school_id=session[:current_user_school_id]
			school=MgSchool.find(mg_school_id)
		  @mg_employee_leave_types = MgEmployeeLeaveType.find(params[:id])
		  puts params[:minimum_month_experience].to_i
          puts params[:minimum_year_experience].to_i*12
        
    	
          @mg_employee_leave_types.update(:minimum_month_experience=>params[:minimum_year_experience].to_i*12+params[:minimum_month_experience].to_i)
		  if @mg_employee_leave_types.update(employees_params)
		  	  if params[:mg_employee_leave_types][:reset_date].present?
		 		@mg_employee_leave_types.update(:reset_date=>Date.strptime(params[:mg_employee_leave_types][:reset_date],school.date_format))
		  		end
		  redirect_to :action=>'index'

		  else
		    render 'edit'
		  end
		end

		def delete

			@mg_employee_leave_types=MgEmployeeLeaveType.find_by_id(params[:id])

			boolVal = MgDependancyClass.empLeaveType_dependancy("mg_leave_type_id",params[:id])
		    if boolVal == true
		      flash[:error]  = "Cannot Delete this Leave Type is Having Dependencies"
		    else
		        @mg_employee_leave_types.is_deleted =1
				@mg_employee_leave_types.save
		        flash[:notice] = "Deleted Successfully"
		    end
		  redirect_to :action => "index"
		end

		def destroy

			@mg_employee_leave_types=MgEmployeeLeaveType.find_by_id(params[:id])
			@mg_employee_leave_types.is_deleted =1
			@mg_employee_leave_types.save
 		
		  redirect_to mg_employee_leave_types
		end

		def emp_attendances

			puts "i'm in emp_attendances"


	 	render :layout => false
			

				
		end

		def reset_all
			

			sql="UPDATE mg_employee_leaves SET leave_taken =0, updated_by=#{session[:user_id]} where mg_school_id=#{session[:current_user_school_id]}"
			ActiveRecord::Base.connection.execute(sql)


			# @house.update_attributes(:colour => newcolour)
			# @subjects =MgEmployeesAttendance.connection.execute("mg_employee_leave_typesupdate mg_employees_attendance set max_leave_count=0")
		
	 		redirect_to :action => 'index'
		end

		def department_reset


			sql="select b.id from mg_employees a, mg_employee_leaves b where a.id = b.mg_employee_id and a.id and a.mg_employee_department_id=#{params[:id]} and a.is_deleted=0 and b.is_deleted=0 and a.mg_school_id=#{session[:current_user_school_id]} and b.mg_school_id=#{session[:current_user_school_id]}"
			@emp_ids=MgEmployee.find_by_sql sql
					for i in 0...@emp_ids.size
							sql="UPDATE mg_employee_leaves SET leave_taken = 0, updated_by=#{session[:user_id]} WHERE id =#{@emp_ids[i].id}"
							ActiveRecord::Base.connection.execute(sql)

					 end
			redirect_to :action => 'index'
		end
		# employeeID: employeeID,
        # employee_id: 'employee_id'

		def individual_employee_leave_reset
			puts "i am in employee individual_employee_leave_reset   -- 1 --"

			if request.xhr?
			puts "i am in employee individual_employee_leave_reset   --  2 --"


				departmentParam=params[:departmentParam]
				employeeCompare=params[:employee_id]
				search_name=params[:search_name]

				
				if(departmentParam=="departmentParam")

					if params[:departmentId].present?

						# sql="select DISTINCT a.mg_employee_id, c.first_name, c.last_name from mg_employee_leaves a, mg_employee_attendances b, mg_employees c where a.mg_employee_id = a.mg_employee_id  and c.id=a.mg_employee_id  and leave_taken>0 and c.mg_employee_department_id=#{params[:departmentId]}"
						sql="select DISTINCT c.id, a.mg_employee_id, c.first_name, c.last_name from mg_employee_leaves a, mg_employee_attendances b, mg_employees c where a.mg_employee_id = a.mg_employee_id  and c.id=a.mg_employee_id  and a.leave_taken>0  and (c.first_name like '%#{params[:employeeName]}%' or c.first_name like '%#{params[:employeeName]}%') and c.mg_employee_department_id=#{params[:departmentId]} and a.is_deleted=0 and c.is_deleted=0 and a.mg_school_id=#{session[:current_user_school_id]} and c.mg_school_id=#{session[:current_user_school_id]}"
						
						@employee_list=MgEmployee.find_by_sql sql
					else
						sql="select DISTINCT c.id, a.mg_employee_id, c.first_name, c.last_name from mg_employee_leaves a, mg_employee_attendances b, mg_employees c where a.mg_employee_id = a.mg_employee_id  and c.id=a.mg_employee_id  and a.leave_taken>0  and (c.first_name like '%#{params[:employeeName]}%' or c.first_name like '%#{params[:employeeName]}%') and a.is_deleted=0 and c.is_deleted=0 and a.mg_school_id=#{session[:current_user_school_id]} and c.mg_school_id=#{session[:current_user_school_id]}"
						
						@employee_list=MgEmployee.find_by_sql sql
					end
					render :json=> {:employee=>@employee_list}
				end

				if("empID"==employeeCompare)
					puts "i am in employee individual_employee_leave_reset  -- 3 --"
					@check_employee=MgEmployeeLeaves.where(:mg_employee_id=>params[:employeeID])
					if @check_employee.length <= 0
					# if @check_employee=MgEmployeeLeaves.where(:mg_employee_id=>params[:employeeID])
						
						@employee_leve_save=MgEmployeeLeaves.new(:mg_employee_id=>params[:employeeID], :leave_taken=>0, :is_deleted=>0, :created_by=>session[:user_id], :updated_by=>session[:params], :mg_school_id=>session[:current_user_school_id])
						# sql="INSERT INTO mg_employee_leaves ( mg_employee_id, leave_taken, is_deleted) VALUES (#{params[:employeeID]},0,0)"
						# ActiveRecord::Base.connection.execute(sql)
						@employee_leve_save.save
						redirect_to :action => 'index'
						puts 'XXXXXXXXXXXXXXXXXXXX'
						puts "i am if"
						puts 'XXXXXXXXXXXXXXXXXXXX'


					else
						puts 'XXXXXXXXXXXXXXXXXXXX'
						puts "i am else"
						puts 'XXXXXXXXXXXXXXXXXXXX'

						sql="UPDATE mg_employee_leaves SET leave_taken = 0, updated_by=#{session[:user_id]} WHERE mg_employee_id =#{params[:employeeID]}"
						ActiveRecord::Base.connection.execute(sql)

						redirect_to :action => 'index'

					end

				end
				if(search_name=='search')
					if params[:departmentId].present?

						# @employee_list=MgEmployee.where(:first_name=> params[:employeeName])
						# @employee_list=MgEmployee.where(:first_name=> "#{'%'+params[:employeeName]+'%'}")
						#sql="select DISTINCT a.mg_employee_id, c.first_name, c.last_name from mg_employee_leaves a, mg_employee_attendances b, mg_employees c where a.mg_employee_id = a.mg_employee_id  and c.id=a.mg_employee_id  and leave_taken>0 and c.mg_employee_department_id=#{params[:departmentId]}"
						sql="select DISTINCT c.id, a.mg_employee_id, c.first_name, c.last_name from mg_employee_leaves a, mg_employee_attendances b, mg_employees c where a.mg_employee_id = b.mg_employee_id  and c.id=a.mg_employee_id and a.leave_taken>0 and (c.first_name like '%#{params[:employeeName]}%' or c.last_name like '%#{params[:employeeName]}%') and c.mg_employee_department_id=#{params[:departmentId]} and a.is_deleted=0 and b.is_deleted=0 and a.mg_school_id=#{session[:current_user_school_id]} and c.mg_school_id=#{session[:current_user_school_id]}"
						# @employee_list = MgEmployee.where("first_name LIKE ?", "%#{params[:employeeName]}%")
						@employee_list=MgEmployee.find_by_sql sql
						puts "iam in search ---1---"
						puts @employee_list.inspect
					else
							# sql="select DISTINCT c.id, a.mg_employee_id, c.first_name, c.last_name from mg_employee_leaves a, mg_employee_attendances b, mg_employees c where a.mg_employee_id = a.mg_employee_id  and c.id=a.mg_employee_id and a.leave_taken>0  and (c.first_name like '%#{params[:employeeName]}%' or c.last_name like '%#{params[:employeeName]}%') and a.is_deleted=0 and c.is_deleted=0 and a.mg_school_id=#{session[:current_user_school_id]} and c.mg_school_id=#{session[:current_user_school_id]}"
								# # @employee_list = MgEmployee.where("first_name LIKE ?", "%#{params[:employeeName]}%")
							# @employee_list=MgEmployee.find_by_sql sql

								# @employee_list=MgEmployee.where(:first_name=> "%#{params[:employeeName]}%")
						 # @employee_list = MgEmployee.where("first_name LIKE ?", "%#{params[:employeeName]}%").where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).select(:id, :first_name, :last_name).uniq
						 @employee_list = MgEmployee.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id])



						puts @employee_list[0].employee_name
					end

					render :json=> {:employee=>@employee_list}


					# search_name: 'search',
     #            employeeName: employeeName
				end

			end


		end


		def from_emp
			@userID=session[:user_id]
			puts @userID
		    school = MgSchool.find_by(:id=>session[:current_user_school_id])
			 previous_month=school.mg_leave_calendar_start_date#.ago(1.month)
 			start_from=previous_month.beginning_of_month
 			 previous_month=Date.today#.ago(1.month)

 			end_to=previous_month.end_of_month

 			@month_start=start_from.strftime('%Y-%m-%d')
 			@month_end=end_to.strftime('%Y-%m-%d')


			@deptId= MgEmployee.where(:mg_user_id => "#{@userID}").pluck(:mg_employee_department_id)
			puts "	===============================	"  
			puts @deptId

			@employee_id=MgEmployee.where(:mg_user_id => "#{@userID}").pluck(:id)
			

			# @isMabager=MgEmployee.where(:mg_manager_id => "#{@userID}")
			#sql="select DISTINCT a.id from mg_employees a, mg_employee_attendances b where a.id = b.mg_employee_id and a.mg_manager_id=#{@userID} and b.is_approved=0"
	        sql="select DISTINCT a.id from mg_employees a, mg_employee_attendances b where a.id = b.mg_employee_id and a.mg_manager_id=#{@employee_id[0]} and b.is_approved=0"
			# sql="select DISTINCT a.created_at, a.id from mg_employees a, mg_employee_attendances b where a.id = b.mg_employee_id and a.mg_manager_id=#{@employee_id[0]}"
	        @isMabager=MgEmployee.find_by_sql sql

            # @isMabager=ActiveRecord::Base.connection.execute(sql)


			puts "==============================="
			puts @deptId
			puts @isMabager.inspect
			puts "==============================="

			puts "step ------1"
			@levee_typs=MgEmployeeLeaveType.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id])
			
			#Shravan
				employee = MgEmployee.find_by(:mg_user_id=>@userID)
				experience_year = employee.experience_year == nil ? 0 : employee.experience_year
				experience_month = employee.experience_month == nil ? 0 : employee.experience_month

				emp_experience = experience_year*12 + experience_month
				emp_gender = Array.new
				emp_marital_status=Array.new
				emp_gender << "all"
				emp_marital_status << "all"
				emp_gender << employee.gender
				if employee.marital_status.present?
					emp_marital_status << employee.marital_status
				end
				emp_type_id = employee.mg_employee_type_id
				
			@shr_leave_types=MgEmployeeLeaveType.where("is_deleted  = 0 AND mg_school_id = #{session[:current_user_school_id]} AND minimum_month_experience <= ? AND gender IN (?) AND mg_employee_type_id =?  AND marital_status IN (?)",emp_experience, emp_gender, emp_type_id, emp_marital_status)
			@levee_typs=@shr_leave_types
			
			#Shravan end
			
          	# @employee_list.push(@levee_typs)
			puts "step ------2"

          	 sql="select a.leave_name, b.leave_taken, a.max_leave_count, a.reset_period from mg_employee_leave_types a, mg_employee_leaves b where a.id=b.mg_leave_type_id and mg_employee_id=#{@employee_id[0]} and a.is_deleted=0 and b.is_deleted=0"
          	
          	# @employee_list=MgEmployeeLeaves.where(:mg_employee_id=> params[:employeeID])
          	@employee_leve=MgEmployee.find_by_sql sql
          	puts "step ------3"

          	@leave=MgEmployeeLeaveApplication.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :mg_employee_id=>@employee_id).paginate(page: params[:page], per_page: 10)
			@school=MgSchool.find(session[:current_user_school_id])
		end

		
		def emp_attendances


			
		end

		def search
	
		if params[:departmentId].present?
			puts "present"
			puts params[:departmentId]
			puts "session[:current_user_school_id]"
			puts session[:current_user_school_id]
	 	# @employee_list = MgEmployee.where("first_name LIKE :name OR last_name LIKE :lastname and is_deleted=0 and mg_school_id =:school and mg_employee_department_id= :department_id", {:name => "%#{params[:employeeName]}%", :lastname=>"%#{params[:employeeName]}%", :school=>session[:current_user_school_id], :department_id=>params[:departmentId]})
	 	sql="SELECT `mg_employees`.* FROM `mg_employees`  WHERE (first_name LIKE '%#{params[:employeeName]}%' OR last_name LIKE '%#{params[:employeeName]}%' ) and is_deleted=0 and mg_school_id =#{session[:current_user_school_id]} and mg_employee_department_id= #{params[:departmentId]}"
		@employee_list = MgEmployee.find_by_sql sql
		else
	 	sql="SELECT `mg_employees`.* FROM `mg_employees`  WHERE (first_name LIKE '%#{params[:employeeName]}%' OR last_name LIKE '%#{params[:employeeName]}%' ) and is_deleted=0 and mg_school_id =#{session[:current_user_school_id]} "
		@employee_list = MgEmployee.find_by_sql sql

		end

	 	render :layout => false
			
		end

		
def server_description(code_s)
    
    case code_s.to_s

          when '0'
              return "Email address is not correct"
        
          when '211'   
              return "A system status message."
          when '214'   
              return "A help message for a human reader follows."
          when '220'   
              return "SMTP Service ready."
          when '221'   
              return "Service closing."
          when '250'   
              return "Requested action taken and completed. The best message of them all."
          when '251'   
              return "The recipient is not local to the server, but the server will accept and forward the message."
          when '252'   
              return "The recipient cannot be VRFYed, but the server accepts the message and attempts delivery."
          when '354'   
              return "Start message input and end with . This indicates that the server is ready to accept the message itself (after you have told it who it is from and where you want to to go)."



          when '421'   
              return "The service is not available and the connection will be closed."
          when '450'   
              return "The requested command failed because the users mailbox was unavailable (for example because it was locked). Try again later."
          when '451'   
              return "The command has been aborted due to a server error. Not your fault. Maybe let the admin know."
          when '452'   
              return "The command has been aborted because the server has insufficient system storage."


          when '500'   
              return "The server could not recognize the command due to a syntax error. "

          when '501'   
              return "A syntax error was encountered in command arguments."
          when '502'   
              return "This command is not implemented."
          when '503'   
              return "The server has encountered a bad sequence of commands."
          when '504'   
              return "A command parameter is not implemented."

          when '550'   
              return "The requested command failed because the users mailbox was unavailable (for example because it was not found, or because the command was rejected for policy reasons)."
          when '551'   
              return "The recipient is not local to the server. The server then gives a forward address to try."
          when '552'   
              return "The action was aborted due to exceeded storage allocation."
          when '553'   
              return "The command was aborted because the mailbox name is invalid."
          when '554'   
              return "The transaction failed. Blame it on the weather."
          
    end
   
  end

	def employee_leave
			# binding.pry

		@all_data = params.require(:mg_employee_leave_types).permit(:half_day_date, :from_date, :to_date, :mg_employee_id, :leave_type, :absent_date, :mg_employee_department_id, :reason, :is_halfday, :is_afternoon, :is_deleted, :is_approved)
		previous_month=Date.today#.ago(1.month)
 		start_from=previous_month.beginning_of_month
 		end_to=previous_month.end_of_month
 		month_start=start_from.strftime('%Y-%m-%d')
 		month_end=end_to.strftime('%Y-%m-%d')
 		mg_school_id=session[:current_user_school_id]
 		@school = MgSchool.find_by(:id=>mg_school_id)
 		leave_start_date = @school.mg_leave_calendar_start_date
    	weekday=[0,1,2,3,4,5,6]
     	my_days = MgEmployeeWeekday.where(:mg_school_id=>mg_school_id,:is_deleted=>0).pluck(:weekday)
     	my_days=weekday-my_days


     	    weekdays_hash=Hash.new
      		weekdays_hash[1]='Monday'
      		weekdays_hash[2]='Tuesday'
      		weekdays_hash[3]='Wednesday'
      		weekdays_hash[4]='Thursday'
      		weekdays_hash[5]='Friday'
      		weekdays_hash[6]='Saturday'
      		weekdays_hash[0]="Sunday"

			begin
				@all_data = params.require(:mg_employee_leave_types).permit(:half_day_date, :from_date, :to_date, :mg_employee_id, :leave_type, :absent_date, :mg_employee_department_id, :reason, :is_halfday, :is_afternoon, :is_deleted, :is_approved)

				@timeformat = MgSchool.find(session[:current_user_school_id])
				if @timeformat.start_time.present?
			     	@school_time=@timeformat.start_time
			    end
			    if params[:mg_employee_leave_types][:from_date].present?
					@from_date = Date.strptime(params[:mg_employee_leave_types][:from_date],@timeformat.date_format)
				end
				if params[:mg_employee_leave_types][:to_date].present?
					@to_date = Date.strptime(params[:mg_employee_leave_types][:to_date],@timeformat.date_format)
				end
				if params[:mg_employee_leave_types][:half_day_date].present?
					@half_day_date = Date.strptime(params[:mg_employee_leave_types][:half_day_date],@timeformat.date_format)
				end
				# MgEmployeeLeaveApplication

				if params[:mg_employee_leave_types][:is_halfday]=='false'
					start_dt=@from_date
					end_dt=@to_date
					total_days=(end_dt.to_date - start_dt.to_date).to_i
					total_days=total_days+1
				  	leave_app=MgEmployeeLeaveApplication.new(leve_app_params)
				  	leave_app.from_date=@from_date
				  	leave_app.to_date=@to_date
				  	leave_app.status="Applied"
				  	leave_app.applied_date=Time.now.strftime("%d-%m-%Y") 
				  	leave_app.mg_employee_leave_type_id=params[:mg_employee_leave_types][:leave_type]
				  	leave_app.save

	 				# @countleave=MgEmployeeLeaves.where(:mg_employee_id=>params[:mg_employee_leave_types][:mg_employee_id], :mg_leave_type_id=>params[:mg_employee_leave_types][:leave_type], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :leave_month_year=>month_start...month_end)
     	# 			@count_leave=@countleave[0]
           			# if @count_leave.present?
			           #  $leave_count=@count_leave.leave_taken
			           #  $leave_taken=$leave_count+total_days
			           #  @count_leave.leave_taken=$leave_taken
			           #  @count_leave.updated_by=session[:user_id]
			           #  @count_leave.save

           			# else
			           #  @leave_new=MgEmployeeLeaves.new(:leave_taken=>total_days, :mg_employee_id=>params[:mg_employee_leave_types][:mg_employee_id], :mg_leave_type_id=>params[:mg_employee_leave_types][:leave_type], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :created_by=>session[:user_id], :updated_by=>session[:user_id], :leave_month_year=>Date.today)
			           #  @leave_new.save
           			# end
	 				  # @countleave_try=MgEmployeeLeaves.where(:mg_employee_id=>params[:mg_employee_leave_types][:mg_employee_id], :mg_leave_type_id=>params[:mg_employee_leave_types][:leave_type], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :leave_month_year=>month_start...month_end)
	 				 date_array=((@from_date)..@to_date).map{|d|[d.year, d.month] }
	 				leave_updation = date_wise_employee_leave_update(@count_leave,date_array,@from_date,@to_date)

	 				 @day_left_count=0

           			for i in 0...total_days
		                date=Date.parse(@from_date.to_s).strftime("%d-%m-%Y")
		                arr = date.split('-');
		                month = arr[1].to_i
		                year =arr[2].to_i
		                day =arr[0].to_i
		                date_format= Date.new(year,month,day) + i


		                savedate=date_format.to_s
		                 # puts "----------------------test---------sunday--------"
                		 # puts date_format.sunday?
                   #       puts "----------------------test---------sunday--------"

                   # Date.today.strftime("%w")
                        # if !date_format.sunday?
                        if my_days.include?(date_format.strftime("%w").to_i)
                        	puts "i there here if --------#{date_format}"
                        	@day_left_count +=1
                        else
                        	puts "i there here else --------#{date_format}"

				        	@employee=MgEmployeeAttendance.new(:mg_employee_leave_application_id=>leave_app.id,:time=>@school_time, :abcent_without_notice=>0,:absent_date=>savedate, :mg_employee_id=>@all_data[:mg_employee_id], :reason=>@all_data[:reason], :is_halfday=>@all_data[:is_halfday], :is_afternoon=>@all_data[:is_afternoon], :mg_employee_department_id=>@all_data[:mg_employee_department_id], :is_deleted=>@all_data[:is_deleted], :is_approved=>0, :mg_leave_type_id=>@all_data[:leave_type], :mg_school_id=>session[:current_user_school_id], :created_by=>session[:user_id], :updated_by=>session[:user_id], :is_late_come=>0) 
				        	@employee.save
				    	end
			    	end
			    	@notice="#{$leavesCount} days Leave applied successful"
				else
					half_day_date_satrt=@half_day_date.beginning_of_month
					half_day_date_end=@half_day_date.end_of_month
					available_leave_type = MgEmployeeLeaveType.find_by(:id=>@all_data[:leave_type]) if @all_data[:leave_type].present?

					if (@half_day_date.month.to_i > leave_start_date.month) && @half_day_date.year.to_i >= leave_start_date.year 

			           months_array = ((leave_start_date)..Date.new(@half_day_date.year.to_i,@half_day_date.month.to_i-1,1)).map{|d| [d.month,d.year]}.uniq

			              months_array.each do |prev_months|
			                new_date = Date.new(prev_months[1],prev_months[0],1)
			           
			            leaves_taken_in_this_year=MgEmployeeLeaves.where(:mg_employee_id=>@all_data[:mg_employee_id], :mg_leave_type_id=>@all_data[:leave_type], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :leave_month_year=>new_date...new_date.end_of_month)

			            @available = leaves_taken_in_this_year[0].available_leave if leaves_taken_in_this_year.present?
			          
			           end
			       end   

				      max_leave_count = available_leave_type.present? ? available_leave_type.max_leave_count : 0.0
				       @available = @available.present? ? @available.to_f : max_leave_count


				    @count_leave=MgEmployeeLeaves.where(:mg_employee_id=>params[:mg_employee_leave_types][:mg_employee_id], :mg_leave_type_id=>params[:mg_employee_leave_types][:leave_type], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id],  :leave_month_year=>half_day_date_satrt.strftime('%Y-%m-%d')...half_day_date_end.strftime('%Y-%m-%d'))
				    leave_available_before = @count_leave.try(:available_leave)

			        if  @count_leave.length > 0
			            @updateEmployeeLeves=MgEmployeeLeaves.find(@count_leave[0].id)
			            @updateEmployeeLeves.leave_taken +=0.5
			            @updateEmployeeLeves.updated_by=session[:user_id]
			            @updateEmployeeLeves.mg_school_id=session[:current_user_school_id]
			            #for updating available leaves
			            total_taken_leaves = (0.5+@updateEmployeeLeves.leave_taken.to_i)

			            @leave_takens  = available_leave_type.monthly_limit > 0  ? (total_taken_leaves > available_leave_type.monthly_limit ? 0.0 : [available_leave_type.monthly_limit, total_taken_leaves].min ): 0.5

                      @updateEmployeeLeves.available_leave = @count_leave[0].available_leave -  @leave_takens
			            @updateEmployeeLeves.save
			        else
			            @updateEmployeeLeves=MgEmployeeLeaves.new(:leave_taken=>0.5, :mg_employee_id=>params[:mg_employee_leave_types][:mg_employee_id], :mg_leave_type_id=>params[:mg_employee_leave_types][:leave_type], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :created_by=>session[:user_id], :updated_by=>session[:user_id],  :leave_month_year=>half_day_date_satrt.strftime('%Y-%m-%d'))
			            @leave_takens  = available_leave_type.monthly_limit > 0 ? [available_leave_type.monthly_limit, 0.5].min : 0.5
                      #month need to be check
                      @updateEmployeeLeves.available_leave = @available - @leave_takens
                      @updateEmployeeLeves.save
		            end

		            leave_updation=LeaveApplication.new

		           leave_nxt_updation =  leave_updation.update_leave_details_of_next_month(@half_day_date,@all_data,leave_available_before,@leave_takens,mg_school_id)


			        leave_app=MgEmployeeLeaveApplication.new(leve_app_params)
			        leave_app.status="Applied"
			        leave_app.from_date=@half_day_date
			        leave_app.to_date=@half_day_date
			        leave_app.mg_employee_leave_type_id=params[:mg_employee_leave_types][:leave_type]
			        leave_app.applied_date=Time.now.strftime("%d-%m-%Y")
			        leave_app.save
			 		@employee=MgEmployeeAttendance.new(:mg_employee_leave_application_id=>leave_app.id, :time=>@school_time, :abcent_without_notice=>0,:absent_date=>@half_day_date, :mg_employee_id=>@all_data[:mg_employee_id], :reason=>@all_data[:reason], :is_halfday=>@all_data[:is_halfday], :is_afternoon=>@all_data[:is_afternoon], :mg_employee_department_id=>@all_data[:mg_employee_department_id], :is_deleted=>@all_data[:is_deleted], :is_approved=>0, :mg_leave_type_id=>@all_data[:leave_type], :mg_school_id=>session[:current_user_school_id], :created_by=>session[:user_id], :updated_by=>session[:user_id], :is_late_come=>0) 
					@employee.save
					@notice="Halfday Leave applied successful"
    			end
    			# notification work start
				employee_obj = MgEmployee.where(:mg_user_id => session[:user_id])#.pluck(:first_name,:middle_name, :last_name)

	            user_obj = MgUser.where(:id => session[:user_id])#.pluck(:user_name)
	            emp_dep = MgEmployeeDepartment.where(:id => employee_obj[0][:mg_employee_department_id])

	            puts emp_dep[0][:department_name].inspect
	            to_principal_user_id=MgUser.where(:user_type=>"principal",:mg_school_id=>session[:current_user_school_id],:is_deleted=>0).pluck(:id)

	            not_sub =   "#{employee_obj[0][:first_name]} #{employee_obj[0][:middle_name]} #{employee_obj[0][:last_name]}(#{user_obj[0][:user_name]})  leave application"

	            not_des ="#{employee_obj[0][:first_name]} #{employee_obj[0][:middle_name]} #{employee_obj[0][:last_name]}  of dept  #{emp_dep[0][:department_name]}  has applied for leave from   #{@all_data[:from_date]}   to  #{@all_data[:to_date]}  with reason \"#{@all_data[:reason]}\"."

	            db_user = MgNotification.create(:mg_school_id => session[:current_user_school_id]   ,:to_user_id => to_principal_user_id[0], :subject => not_sub,:description => not_des,:is_deleted => 0, :from_user_id => session[:user_id],:status => false )
	           
            	@message = Message.new
			  	@email_from = MgEmail.where(:mg_user_id => session[:user_id],mg_school_id:session[:current_user_school_id])

				@message.subject =  not_sub
 		    	@message.description = not_des
 		    	@email_to = MgEmail.where(:mg_user_id => to_principal_user_id[0],mg_school_id:session[:current_user_school_id])

		    	@message.to_user_id = @email_to[0][:mg_email_id ]
			    @message.from_user_id = @email_from[0][:mg_email_id ]
			 	server_response = NotificationMailer.send_mail(@message).deliver!
			 	@event_mail = MgMailStatus.create(:status_code => server_response.status,
		                                            :email_addrs_to => @message.to_user_id,
		                                            # current school Id will come here
                            						:mg_school_id => session[:current_user_school_id] ,
		                                            :email_addrs_by => @message.from_user_id,
		                                            :email_subject => not_sub,
		                                           :email_server_description => server_description(server_response.status) )
				#notification work end
				@notice_exception="Email sent successfully."
		    rescue Net::SMTPFatalError => e
		      	@notice_exception='Email-Id is not valid.'
		    rescue ArgumentError=>e
      			@notice_exception='Email to address is not present.'
    		rescue Exception=>e
      			@notice_exception='Error while sending email, please contact admin.'
			end
		redirect_to :controller => 'mg_employee_leave_types', :action =>'from_emp', notice: @notice+" "+@notice_exception
	end


	def date_wise_employee_leave_update(countleave,date_array,from_date,to_date)
		    mg_school_id = session[:current_user_school_id]
		date_count=dup_hash(date_array)
		user_id =session[:user_id]


			date_count.each do |key,value|
				date = []
				holidayDates = []
				date = (from_date..to_date).map(&:to_s)
				minusHoliday = 0
				holidayDates = []
				start_of_month1=Date.new(key[0].to_i,key[1].to_i.to_i,1)
				end_of_month1=start_of_month1.end_of_month
				 holiday_result = MgHoliday.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:holiday_start_date,:holiday_end_date)
        			holiday_result.each do |hdate|
       				holidayDates = (hdate[0]..hdate[1]).map(&:to_s)
       				holidayDates.each do |hdate|
	        			if date.include? hdate
	        				date -= [hdate]
	        			end
        				end
        			end
        			value =  date.length
					result=no_of_sunday_leave(date)
        			$leavesCount = date.length - result 
        		from_date=from_date+value

        		all_data = params[:mg_employee_leave_types]
                 leave_updation=LeaveApplication.new
                 leave_updation_data=leave_updation.leave_deduction(key,value,result,all_data,mg_school_id,user_id)

		 			# countleave=MgEmployeeLeaves.where(:mg_employee_id=>params[:mg_employee_leave_types][:mg_employee_id], :mg_leave_type_id=>params[:mg_employee_leave_types][:leave_type], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :leave_month_year=>start_of_month1...end_of_month1)
		 			# puts countleave.inspect
		 			# puts "-------------------------------"
		 			# if countleave[0].present?
		 			# 	puts "in if"
		 			# 	leave_count=countleave[0].leave_taken
				  #       leave_taken=leave_count+($leavesCount)
				  #       countleave[0].leave_taken=leave_taken
				  #       countleave[0].updated_by=session[:user_id]
				  #       countleave[0].save
				  #   else
				  #   	puts "else"
				  #   	countleave_new=MgEmployeeLeaves.new(:leave_taken=>($leavesCount),:mg_employee_id=>params[:mg_employee_leave_types][:mg_employee_id], :mg_leave_type_id=>params[:mg_employee_leave_types][:leave_type], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :leave_month_year=>start_of_month1)
		 			# 	countleave_new.save
		 			# end
			end
		
	end

	def no_of_sunday_leave(date)
     	# my_days = [0]
     	mg_school_id=session[:current_user_school_id]
    	weekday=[0,1,2,3,4,5,6]
     	my_days = MgEmployeeWeekday.where(:mg_school_id=>mg_school_id,:is_deleted=>0).pluck(:weekday)
     	my_days=weekday-my_days
     	result = date.select {|k|
        	k = Date.parse k 
         my_days.include?(k.wday)}
    	return result.count
  	end

	def dup_hash(ary)
	  	ary.inject(Hash.new(0)) { |h,e| h[e] += 1; h }.select { 
	    |k,v| v > 1 }.inject({}) { |r, e| r[e.first] = e.last; r }
	end


	def no_of_sunday(start_of_month,end_of_month)
     	# my_days = [0]
     	mg_school_id=session[:current_user_school_id]
    	weekday=[0,1,2,3,4,5,6]
     	my_days = MgEmployeeWeekday.where(:mg_school_id=>mg_school_id,:is_deleted=>0).pluck(:weekday)
     	my_days=weekday-my_days
        result = (start_of_month..end_of_month).to_a.select {|k| my_days.include?(k.wday)}
    	return result.count
  	end

def validate_employee_leave

	previous_month=Date.today#.ago(1.month)
		start_from=previous_month.beginning_of_month
		end_to=previous_month.end_of_month
		month_start=start_from.strftime('%Y-%m-%d')
		month_end=end_to.strftime('%Y-%m-%d')
	if request.xhr?
		puts "start from here....."
		puts params[:leave_type]
		puts params[:from_date]
		puts params[:to_date]
		puts params[:half_day_date]
		puts params[:is_halfday]
		puts params[:mg_employee_id]
		puts "end....."
		@timeformat = MgSchool.find(session[:current_user_school_id])

		if @timeformat.start_time.present?
 			@school_time=@timeformat.start_time
 		end

     	if params[:from_date].present?
			@from_date = Date.strptime(params[:from_date],@timeformat.date_format)
		end
		if params[:to_date].present?
			@to_date = Date.strptime(params[:to_date],@timeformat.date_format)

		end
		if params[:half_day_date].present?
			@half_day_date = Date.strptime(params[:half_day_date],@timeformat.date_format)
		end
		# ckecK_date=MgEmployeesAttendance.where(:is_deleted=>0)				
		if (params[:from_date].present? && params[:to_date].present?) || params[:half_day_date].present?	
		puts "inside"			

			if MgEmployeeAttendance.where(:is_deleted=>0, :is_approved=>[1,0], :mg_employee_id=>params[:mg_employee_id], :absent_date=>@from_date..@to_date ).present? || MgEmployeeAttendance.where(:is_deleted=>0, :is_approved=>[1,0], :mg_employee_id=>params[:mg_employee_id], :absent_date=>@half_day_date).present?
				@notice="Leave is already applied for selected date."
			else
				if params[:is_halfday]=='false'												
					if @from_date.present? && @to_date.present?	
						 # previous_month=Date.today#.ago(1.month)
						start_from=@from_date.beginning_of_month
						end_to=@from_date.end_of_month
						month_start=start_from.strftime('%Y-%m-%d')
						month_end=end_to.strftime('%Y-%m-%d')
						puts "test-----start----[#{month_start}]-------------end---------[#{month_end}]"
						puts "test-----start----[#{month_start}]-------------end---------[#{month_end}]"
						puts "test-----start----[#{month_start}]-------------end---------[#{month_end}]"
						puts "test-----start----[#{month_start}]-------------end---------[#{month_end}]"
						puts "test-----start----[#{month_start}]-------------end---------[#{month_end}]"
						puts "test-----start----[#{month_start}]-------------end---------[#{month_end}]"
						puts "test-----start----[#{month_start}]-------------end---------[#{month_end}]"
						puts "test-----start----[#{month_start}]-------------end---------[#{month_end}]"
					 	week_ends=no_of_sunday(@from_date,@to_date)
# week_ends=0
						puts "inside if"
						start_dt =@from_date
						end_dt =@to_date
						total_days =(end_dt.to_date - start_dt.to_date).to_i
						total_days =total_days+1-week_ends
						@balance_check=MgEmployeeLeaves.where(:is_deleted=>0, :mg_employee_id=>params[:mg_employee_id], :mg_leave_type_id=>params[:leave_type], :mg_school_id=>session[:current_user_school_id], :leave_month_year=>month_start...month_end).pluck(:leave_taken)
				     	if !@balance_check.present?
				     		@balance_check[0]=0
				     	end						     	# binding.pry
			     		@leave_type_check=MgEmployeeLeaveType.find(params[:leave_type])
				     	if @leave_type_check.min_leave_count.to_i <=total_days.to_i
					     	if @leave_type_check.max_leave_count>=total_days+@balance_check[0]
				   				@notice="successful"
					     	else
			     				@notice="Cannot apply #{total_days} days for #{@leave_type_check.leave_name} leave, your total leave exceeded #{@leave_type_check.max_leave_count} days."
					     	end
						else 
							@notice="Cannot apply #{total_days} days for #{@leave_type_check.leave_name} leave , minimum #{@leave_type_check.min_leave_count} days are required."

						end
					else
						@notice="successful"
					end					
			    else
					puts "inside else"
					@balance_check=MgEmployeeLeaves.where(:is_deleted=>0, :mg_employee_id=>params[:mg_employee_id], :mg_leave_type_id=>params[:leave_type], :mg_school_id=>session[:current_user_school_id],  :leave_month_year=>month_start...month_end).pluck(:leave_taken)
				  	if !@balance_check.present?
			     		@balance_check[0]=0
			     	end
			     	@leave_type_check=MgEmployeeLeaveType.find(params[:leave_type])
		     		puts "@leave_type_check.min_leave_count "
		     		puts @leave_type_check.min_leave_count 
		     		if @leave_type_check.min_leave_count.to_f <=0.5
		     			puts "in side min count"
				     	if @leave_type_check.max_leave_count>=0.5+@balance_check[0]			     		
				   			@notice="successful"
					    else
					     	# @notice="your not eligible for apply #{@leave_type_check.leave_name} type of leave"
					     	@notice="Cannot apply half day for #{@leave_type_check.leave_name} leave, your total leave exceeded #{@leave_type_check.max_leave_count} days. "
					    end
					else 
						# @notice="selected leave type must greater then #{@leave_type_check.min_leave_count} days"
						@notice="Cannot apply half day for #{@leave_type_check.leave_name} leave, minimum #{@leave_type_check.min_leave_count} days are required."

					end
		    	end
			end

	    	if params[:is_halfday]=='false' 
	    		if MgEmployeeAttendance.where(:is_deleted=>0, :is_approved=>[1,0], :mg_employee_id=>params[:mg_employee_id], :absent_date=>@half_day_date).present?
				@notice="Leave is already applied for selected date."
				else
			    	if @from_date.present? && @to_date.present? && params[:is_halfday]=='false' 
						if @from_date.to_date<=@to_date.to_date 
						else
						@notice="From Date should be Greter then To Date."
						end
					else
						puts "i am here"
						@notice="successful"
					end 
				end
			end
		else
			@notice="fill_form"
		end
		notice_msg = Hash["notice" => @notice]								
		render :json=> notice_msg
	end
end

		def for_manager_attendence
			
		end


		def approve_leave_by_manager
			@leave_apprve=MgEmployeeAttendance.where(:mg_employee_id => params[:id])
			@employeeID=params[:id]

			# 			absent_date, 
			# mg_employee_id, 
			# mg_leave_type_id, 
			# reason, 
			# is_halfday, 
			# is_afternoon, 
			# mg_employee_department_id, 
			# is_approved, 
			# sql="select absent_date , min(absent_date), max(absent_date) from mg_employee_attendances where mg_employee_id=#{params[:id]}"
			# sql="select mg_employee_id, mg_leave_type_id, absent_date , min(absent_date) min_date, max(absent_date) max_date from mg_employee_attendances where mg_employee_id=#{params[:id]}"
			# @leave_apprve_from_to=MgEmployee.find_by_sql sql

			# sql="select mg_employee_id, mg_leave_type_id, absent_date , min(absent_date) min_date, max(absent_date) max_date from mg_employee_attendances where created_at='2015-01-14 09:28:05' and mg_employee_id=55"


			sql_created="select DISTINCT a.created_at from mg_employee_attendances a, mg_employee_attendances b where a.mg_employee_id=#{params[:id]} and a.is_deleted=0 and a.is_approved=0"
			@sql_created=MgEmployeeAttendance.find_by_sql sql_created

			


	 	render :layout => false

		end

		def is_approve
		@updateEmployee=MgEmployeeAttendance.where(:mg_employee_id=>params[:id], :is_approved=>0, :is_deleted=>0)
		@updateEmployee.each do |a|
		leve_id=a.mg_leave_type_id
		@count_leave=MgEmployeeLeaves.where(:mg_employee_id => params[:id], :mg_leave_type_id=>leve_id)#.pluck(:id)
					if 	@count_leave.length > 0
						@updateEmployeeLeves=MgEmployeeLeaves.find(@count_leave[0].id)
						@updateEmployeeLeves.leave_taken +=1
						@updateEmployeeLeves.save
                   else
                   	@updateEmployeeLeves=MgEmployeeLeaves.new(:mg_employee_id=>params[:id],:mg_leave_type_id=>a.mg_leave_type_id, :leave_taken=>1, :is_deleted=>0 )
                    @updateEmployeeLeves.save
                   end
         end
        sqlquery="UPDATE mg_employee_attendances SET is_approved = 1 WHERE mg_employee_id=#{params[:id] } and is_approved=0"
		ActiveRecord::Base.connection.execute(sqlquery)
		redirect_to :action => "from_emp"
		end

		def is_not_approve
		sql="UPDATE mg_employee_attendances SET is_approved = 2 WHERE mg_employee_id=#{params[:id]} and is_approved=0"
		ActiveRecord::Base.connection.execute(sql)
			redirect_to :action => "from_emp"
		end

		def leave_for_approve
			# puts params[:search_by]
			# @leave=MgEmployeeLeaveApplication.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).search(params[:search]).paginate(page: params[:page], per_page: 10)#, :status=>'Applied'
			# @school=MgSchool.find(session[:current_user_school_id])

				if (params[:search_by]=="mg_employee_id")
					@emp_data = "mg_employee_id"
						@leave=MgEmployeeLeaveApplication.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).search_by_name(params[:search]).paginate(page: params[:page], per_page: 10)#, :status=>'Applied'
						@school=MgSchool.find(session[:current_user_school_id])
						render :layout => false
					elsif (params[:search_by]=="mg_employee_leave_type_id")
						@emp_data = "mg_employee_leave_type_id"
						@leave=MgEmployeeLeaveApplication.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).search_by_leave_type(params[:search]).paginate(page: params[:page], per_page: 10)#, :status=>'Applied'
						@school=MgSchool.find(session[:current_user_school_id])
						render :layout => false
					elsif (params[:search_by]=="status")
						@emp_data = "status"
						puts @emp_data 
						@leave=MgEmployeeLeaveApplication.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).search_by_status(params[:search]).paginate(page: params[:page], per_page: 10)#, :status=>'Applied'
						@school=MgSchool.find(session[:current_user_school_id])
						render :layout => false
						else
							# puts "else"
							# gggg
						@leave=MgEmployeeLeaveApplication.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)#, :status=>'Applied'
						@school=MgSchool.find(session[:current_user_school_id])
					end
			# render :layout => false 
		end

		# def employee_leave_search_data
		# 	puts params[:search_by]
		# 			puts "============================"
		# 	puts "============================"
		# 	puts "============================"
		# 	puts "============================"
		# 	# llll

		# 		if (params[:search_by]=="mg_employee_id")
		# 			@emp_data = "mg_employee_id"
		# 		@leave=MgEmployeeLeaveApplication.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).search(params[:search]).paginate(page: params[:page], per_page: 10)#, :status=>'Applied'
		# 		@school=MgSchool.find(session[:current_user_school_id])
		# 	elsif (params[:search_by]=="mg_employee_leave_type_id")
		# 		@emp_data = "mg_employee_leave_type_id"
		# 		@leave=MgEmployeeLeaveApplication.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).search(params[:search]).paginate(page: params[:page], per_page: 10)#, :status=>'Applied'
		# 		@school=MgSchool.find(session[:current_user_school_id])
		# 	elsif (params[:search_by]=="status")
		# 		@emp_data = "status"
		# 		@leave=MgEmployeeLeaveApplication.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).search(params[:search]).paginate(page: params[:page], per_page: 10)#, :status=>'Applied'
		# 		@school=MgSchool.find(session[:current_user_school_id])
		# 		else
		# 		@leave=MgEmployeeLeaveApplication.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).paginate(page: params[:page], per_page: 10)#, :status=>'Applied'

		# 	end
		# 	render :layout => false 
		# end
		def leave_action
			puts params[:mg_employee_leave_application_id]
			@mg_employee_leave_application=params[:mg_employee_leave_application_id]
	 		render :layout => false
		end

		def leave_action_save
			school_id=session[:current_user_school_id]
				@school=MgSchool.find(session[:current_user_school_id])
				@notice=" "
		begin
			
		
			MgEmployeeLeaveApplication.transaction do
				# MgEmployeeLeaveApplication.transaction do
					if params[:approve]== "approve-leave"
						leave_apprve=MgEmployeeLeaveApplication.find(params[:mg_employee_leave_application_id])
						leave_apprve.status_date=Time.now.strftime("%d-%m-%Y")
						leave_apprve.updated_by=session[:user_id]
						leave_apprve.status="Approved"
						leave_apprve.save

						leave_count=MgEmployeeAttendance.where(:is_deleted=>0, :mg_employee_leave_application_id=> params[:mg_employee_leave_application_id])
						leave_count.update_all(:is_approved=>1)
			            @not_des ="Your leave application from #{leave_apprve.from_date.strftime(@school.date_format)} to #{leave_apprve.to_date.strftime(@school.date_format)} has been approved."
						@notice_message = "leave approved successfully."
					else
						puts "i am in else condition"
						puts "testing for leave reject leave application"
						leave_apprve=MgEmployeeLeaveApplication.find(params[:mg_employee_leave_types][:mg_employee_leave_application_id])
						leave_apprve.status_date=Time.now.strftime("%d-%m-%Y")
						leave_apprve.updated_by=params[:mg_employee_leave_types][:updated_by]
						leave_apprve.status="Rejected"
						leave_apprve.reject_reason=params[:mg_employee_leave_types][:reject_reason]
						leave_apprve.save

						reject=MgEmployeeAttendance.where(:is_deleted=>0, :mg_employee_leave_application_id=> params[:mg_employee_leave_types][:mg_employee_leave_application_id], :mg_school_id=>school_id)

						puts "puts check half day or not-----"
						puts "puts check half day or not-----"
						puts  
						puts "puts check half day or not-----"
						puts "puts check half day or not-----"

						from_date=Date.parse(leave_apprve.from_date.to_s)
								to_date=Date.parse(leave_apprve.to_date.to_s)
								@result=no_of_sunday(from_date,to_date)
								start_from=from_date.beginning_of_month
		 						end_to=from_date.end_of_month

		 						date_array=((from_date)..to_date).map{|d|[d.year, d.month] }

		 						puts "date_array------:#{date_array.inspect}"
		 						date_count=dup_hash(date_array)
		 						

		 		if reject.present?
						if reject[0].is_halfday
								start_month_half_day=from_date.beginning_of_month 
		 						end_month_half_day=from_date.end_of_month
		 						start_month_half_day=start_month_half_day.strftime('%Y-%m-%d')
		 						end_month_half_day=end_month_half_day.strftime('%Y-%m-%d')

								countleave=MgEmployeeLeaves.where(:is_deleted=>0, :mg_school_id=>school_id, :mg_leave_type_id=>leave_apprve.mg_employee_leave_type_id, :mg_employee_id=>leave_apprve.mg_employee_id,  :leave_month_year=>start_month_half_day...end_month_half_day)
								if countleave[0].present?
									half_day_leave=countleave[0].leave_taken
									if(half_day_leave-0.5) <0
										countleave[0].leave_taken=0
									else
										countleave[0].leave_taken=half_day_leave-0.5
									end
									countleave[0].save
								end

						else

							
		 						 	date_count.each do |key,value|
										puts "#{key}-----#{value}"
										puts key[0]
										puts key[1]
										puts "#{key}-----#{value}"


									 	start_of_month1=Date.new(key[0].to_i,key[1].to_i.to_i,1)
										end_of_month1=start_of_month1.end_of_month

									# no_of_sunday=no_of_sunday(start_of_month1,end_of_month1)
										result=no_of_sunday(from_date,from_date+value-1)
						         		from_date=from_date+value

							 			# countleave=MgEmployeeLeaves.where(:mg_employee_id=>params[:mg_employee_leave_types][:mg_employee_id], :mg_leave_type_id=>params[:mg_employee_leave_types][:leave_type], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :leave_month_year=>start_of_month1...end_of_month1)
								countleave=MgEmployeeLeaves.where(:is_deleted=>0, :mg_school_id=>school_id, :mg_leave_type_id=>leave_apprve.mg_employee_leave_type_id, :mg_employee_id=>leave_apprve.mg_employee_id,  :leave_month_year=>start_of_month1...end_of_month1)
							 	
							 	 		puts countleave.inspect
							 			if countleave[0].present?
							 	 			leave_count=countleave[0].leave_taken
									        # leave_taken=leave_count-(value-result)
								       		


									        if(leave_count-(value-result)) <0
												leave_taken=0
												puts "i'm in if-----"
											else
												leave_taken=leave_count-(value-result)
												puts "i'm in else-----:#{leave_taken}"

								 			end
								 			puts "leave_taken-------:=>#{leave_taken}"
								 			countleave[0].leave_taken=leave_taken
									      	countleave[0].updated_by=session[:user_id]
									        countleave[0].save
									    # else

									#     	countleave_new=MgEmployeeLeaves.new(:leave_taken=>(value-result),:mg_employee_id=>params[:mg_employee_leave_types][:mg_employee_id], :mg_leave_type_id=>params[:mg_employee_leave_types][:leave_type], :is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :leave_month_year=>start_of_month1)
							 	# 			countleave_new.save
							 		end

								end

						end

					end

						




						puts "result--------:#{@result}"
						

						reject.update_all(:is_approved=>2)
			            @not_des ="Your leave application from #{leave_apprve.from_date.strftime(@school.date_format)} to #{leave_apprve.to_date.strftime(@school.date_format)} was rejected because of #{leave_apprve.reject_reason}"
						$notice_msg=" leave rejected successfully."
						# puts vhkdfhgkhfkh

						puts "testing for leave reject leave application"
					
					end
				# else
				# 	$notice_msg=" leave rejection is successful. please contact administration"
				end

			rescue Exception => e
				puts e
				$notice_msg=" leave rejection is successful. please contact administration"
			end

			begin
				#Notification Start
				puts "Inside Notification===="
				puts leave_apprve.inspect
				not_sub ="Leave Status"
				leave_of_employee=MgEmployee.find(leave_apprve.mg_employee_id)
	       		puts "Employee Detail"
	       		puts leave_of_employee.inspect
	            db_user = MgNotification.create(:mg_school_id => session[:current_user_school_id],:to_user_id => leave_of_employee.mg_user_id, :subject => not_sub,:description => @not_des,:is_deleted => 0, :from_user_id => session[:user_id],:status => false )
	       		
	        	@message = Message.new
			  	@email_from = MgEmail.where(:mg_user_id => session[:user_id],mg_school_id:session[:current_user_school_id])

				@message.subject =  not_sub
			    @message.description = @not_des
			    @email_to = MgEmail.where(:mg_user_id => leave_of_employee.mg_user_id,mg_school_id:session[:current_user_school_id])
			    @message.to_user_id = @email_to[0][:mg_email_id ]
				@message.from_user_id = @email_from[0][:mg_email_id ]
				    		   
				server_response = NotificationMailer.send_mail(@message).deliver!

				@event_mail = MgMailStatus.create(:status_code => server_response.status,
			                                            :email_addrs_to => @message.to_user_id,
			                                            # current school Id will come here
	                            						:mg_school_id => session[:current_user_school_id] ,
			                                            :email_addrs_by => @message.from_user_id,
			                                            :email_subject => not_sub,
			                                           :email_server_description => server_description(server_response.status) )

				@notice="Mail sent successfully."
				#Notification Ends
			rescue Net::SMTPFatalError => e
				if request.xhr?
					@notice="Email Id is not valid."
				else
					@notice="Email Id is not valid."
				end
			rescue ArgumentError => e
				if request.xhr?
					@notice=" Email to address is not present."
				else
					@notice="Email to address is not present."
				end
			rescue Exception => e
				if request.xhr?
					@notice="Error while sending email, please contact admin."
				else
					@notice="Error while sending email, please contact admin."
				end	
			end

			if request.xhr?
				flash[:notice]=@notice_message + " " +@notice 
		  		flash.keep(:notice) 
				render :js => "window.location = #{leave_for_approve_path.to_json}"
			else
				redirect_to :action => "leave_for_approve", :notice=>$notice_msg + @notice
			end
		end


  private



  def leve_app_params

  	params.require(:mg_employee_leave_types).permit(:is_deleted, :mg_employee_id, :is_halfday, :is_afternoon, :from_date, :to_date, :created_by, :updated_by,  :mg_school_id, :reason)
  end
  def employees_params

    params.require(:mg_employee_leave_types).permit(:marital_status,:is_showable,:leave_name, :leave_code, :min_leave_count,:max_leave_count,:accumilation_period,:accumilation_count,:carry_forward_limit,:is_auto_reset, :reset_date, :reset_period, :is_carry_forward, :is_deleted, :mg_school_id, :created_by, :updated_by,:mg_employee_type_id, :is_accumilation,:minimum_month_experience,:gender,:is_leave_should_not_be_deducted,:monthly_limit,:delay_deduction,:delay_time,:delay_days,:leave_deduction_count)
  end
end


