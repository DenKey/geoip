# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      around_action :run_action

      private

      def error(message, status)
        @errors = [{status: status, title: message}]

        render :error, formats: [:json], handlers: [:jbuilder]
      end

      def run_action
        yield
      rescue StandardError => e
        case e
        when ActiveRecord::RecordNotFound
          error("Requested record not found", STATUS_MISSING_RESOURCE_ERROR)
        when ActiveRecord::RecordInvalid, ActionController::ParameterMissing
          error("Something wrong with data that we get from you. Please try again.", STATUS_PARAMETER_ERROR)
        else
          error("There seems to be a problem. Please try again in a little while.", STATUS_SERVER_ERROR)
        end
      ensure
        # Development version of logging. We can use any specified services here
        Rails.logger.info(e)
      end
    end
  end
end
