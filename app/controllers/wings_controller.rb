class WingsController < ApplicationController
  layout "mindcom"

  def index
    @school_data = { academic_year: ["2022-2023","2023-2024"], class: ["I","II","III"] }
  end

  def show
  end

  def create
    # Get the academic_year from the request parameters
    academic_year = params[:academic_year]

    # Check if academic_year is present
    if academic_year.blank?
      render json: { error: "Academic year cannot be blank" }, status: :unprocessable_entity
      return
    end

    # Print the received academic_year to the server logs
    Rails.logger.info("Received academic year: #{academic_year}")

    # Optionally, send a JSON response back to the React component
    render json: { message: "Academic year received", academic_year: academic_year }, status: :created
  end

  private

  def wing_params
    # Use strong parameters to permit the academic_year parameter
    params.permit(:academic_year)
  end
end
