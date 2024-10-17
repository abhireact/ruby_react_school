class SportsController < ApplicationController
    layout "mindcom"
  
    def index
        @sports = MgSport.where(is_deleted: false, mg_school_id: session[:current_user_school_id])
        respond_to do |format|
            format.html # renders the default index.html.erb
            format.json do
              if params[:api_request].present?
                render json: @sports, status: :created
              else
                render json: { error: "API request parameter missing" }, status: :bad_request
              end
            end
          end
    end
  
    # POST /wings
    def create
        @sports=MgSport.new(stud_hobby_params)
        @sports.mg_school_id = session[:current_user_school_id]
        @sports.is_deleted= 0
        @sports.created_by= session[:user_id]
        @sports.updated_by= session[:user_id]
        if @sports.save
          render json: { message: "Sports Created"}, status: :created
        end

    end
  
    # PATCH/PUT /academic_years/:id
    def update
            # binding.pry
            @stud_hobby = MgHobby.find(params[:id])
            if @stud_hobby.update(stud_hobby_params)
              render json: { message: "Student Hobby Updated"}, status: :created
            end
    end


    # DELETE /academic_years/:id
    def destroy

            @hobby=MgHobby.find(params[:id])
              # res = view_context.find_dependency("mg_caste_id",params[:id])
       
           boolVal = MgDependancyClass.student_hobby_dependancy("mg_hobby_id",params[:id])
           if boolVal == true
             flash[:error]  = "Cannot Delete this Caste is Having Dependencies"
           else
              @hobby.update(:is_deleted=>1)
               flash[:notice] = "Deleted Successfully"
            end
        
           render json: { message: "Academic year Created"}, status: :created  
    end


          private
          def sport_params
            params.require(:mg_sport).permit(:name,:description,:is_deleted,:mg_school_id,:updated_by,:created_by)
       end
        
  end
  