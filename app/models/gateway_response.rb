class GatewayResponse < ApplicationRecord
  store(:merchDetails, { coder: JSON })
  store(:payDetails, { coder: JSON })
  store(:payModeSpecificData, { coder: JSON })
  store(:extras, { coder: JSON })
  store(:custDetails, { coder: JSON })
  store(:responseDetails, { coder: JSON })

  def self.create_new(decrypted_data, params)
    data = decrypted_data.[]("payInstrument")
    response = GatewayResponse.new({ merchDetails: data.[]("merchDetails"), payDetails: data.[]("payDetails"), payModeSpecificData: data.[]("payModeSpecificData"), extras: data.[]("extras"), custDetails: data.[]("custDetails"), responseDetails: data.[]("responseDetails") })
    response
  end
end
