# frozen_string_literal: true

module Geolocation
  class BaseGeodata
    def validate_data(data)
      if data.nil?
        { errors: [{title: "API doesn't response", status: STATUS_SERVER_ERROR}]}
      end

      if data.try(:[], :success) == false
        {errors: [{title: data.fetch(:error).fetch(:info), status: STATUS_PARAMETER_ERROR}]}
      end
    end

    def activerecord_error
      {
        errors: [{title: 'Something went wrong please try later', status: STATUS_SERVER_ERROR}]
      }
    end
  end
end
