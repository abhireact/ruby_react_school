module JsonResponseHelper
  extend ActiveSupport::Concern

  # Helper to render JSON responses with status
  def render_json_response(object, status = :ok)
    render json: object, status: status
  end

  # Helper to handle and log errors, and provide standardized error responses
  def handle_error(error)
    Rails.logger.error error.message
    Rails.logger.error error.backtrace.join("\n")
    render json: { error: error.message }, status: :internal_server_error
  end

  # Wraps any action in an async promise
        # #js async wrapper example
        #   const asyncHandler = (requestHandler) => {
        #     return (req, res, next) => {
        #         Promise.resolve(requestHandler(req, res, next)).catch((err) => next(err))
        #     }
        # }
        # export { asyncHandler }

  def async_action(&block)
  promise = Concurrent::Promise.execute(&block)

  # Wait for the promise to complete and catch any errors if they occur
    begin
      promise.wait!  # This will block until the action completes
    rescue => error
      handle_error(error)
    end
  end

end
