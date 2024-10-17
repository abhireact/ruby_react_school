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
        @sports=MgSport.new(sport_params)
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
            @sports = MgSport.find(params[:id])
            if @sports.update(sport_params)
              render json: { message: "Sports Updated"}, status: :created
            end
    end


    # DELETE /academic_years/:id
    def destroy

            @sports=MgSport.find(params[:id])
       
           boolVal = MgDependancyClass.student_sports_dependancy("mg_sport_id",params[:id])
           if boolVal == true
             flash[:error]  = "Cannot Delete this Sports is Having Dependencies"
           else
              @sports.update(:is_deleted=>1)
               flash[:notice] = "Deleted Successfully"
            end
        
           render json: { message: "Sports "}, status: :created  
    end


          private
          def sport_params
            params.require(:sports).permit(:name,:description,:is_deleted,:mg_school_id,:updated_by,:created_by)
       end
        
  end
  