class HousesController < ApplicationController
    layout "mindcom"
  
    def index
        @house_details = MgHouseDetails.where(is_deleted: false, mg_school_id: session[:current_user_school_id])
        respond_to do |format|
            format.html # renders the default index.html.erb
            format.json do
              if params[:api_request].present?
                render json: @house_details, status: :created
              else
                render json: { error: "API request parameter missing" }, status: :bad_request
              end
            end
          end
    end
  
    # POST /wings
    def create
        @house_details=MgHouseDetails.new(house_details_params)
        @house_details.mg_school_id = session[:current_user_school_id]
        @house_details.is_deleted= 0
        @house_details.created_by= session[:user_id]
        @house_details.updated_by= session[:user_id]
        if @house_details.save
          render json: { message: "Academic year Created"}, status: :created
        end

    end
  
    # PATCH/PUT /academic_years/:id
    def update
            # binding.pry
            @house_details = MgHouseDetails.find(params[:id])
            if @house_details.update(house_details_params)
              render json: { message: "House Name Updated"}, status: :created
            end
    end


    # DELETE /academic_years/:id
    def destroy

        @house_details = MgHouseDetails.find(params[:id])
        @house_details.update(is_deleted: true)
        
           render json: { message: "Academic year Created"}, status: :created  
    end


          private
          def house_details_params
            params.require(:houses).permit(:Name,:Description,:is_deleted,:mg_school_id,:updated_by,:created_by)
       end
        
  end
  