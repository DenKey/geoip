module Api
  module V1
    class IpAddressesController < BaseController
      before_action :check_params
      before_action :set_service

      def create
        @data = @service.add(@resource)

        if error?(@data)
          @errors = @data[:errors]
          render 'api/v1/base/error', formats: [:json], handlers: [:jbuilder]
        else
          render :create, formats: [:json], handlers: [:jbuilder]
        end
      end

      def lookup
        @data = @service.lookup(@resource)

        if error?(@data)
          @errors = @data[:errors]
          render 'api/v1/base/error', formats: [:json], handlers: [:jbuilder]
        else
          render :lookup, formats: [:json], handlers: [:jbuilder]
        end
      end

      def delete
        model = @service.find_model(@resource)

        if error?(model)
          @errors = model[:errors]
          render 'api/v1/base/error', formats: [:json], handlers: [:jbuilder]
        else
          model.destroy!
          render json:'ok', status: 200
        end
      end

      private

      def check_params
        @resource = params.dig(:data, :resource)
      end

      def set_service
        @service = Geolocation::Service.new
      end
    end
  end
end
