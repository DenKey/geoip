# frozen_string_literal: true

module Geolocation
  class Service
    def initialize
      @provider = Ipstack::Service.new
    end

    def add(string)
      type, resource = ResourceParser.call(string)

      case type
      when :ip
        FindOrCreateByIp.new(@provider).call(resource)
      when :domain
        FindOrCreateByDomain.new(@provider).call(resource)
      else
        {
          errors: [{title: 'Input format is not valid', status: STATUS_PARAMETER_ERROR} ]
        }
      end
    end

    def lookup(string)
      model = self.find_model(string)

      if model.is_a?(Domain)
        model.ip_addresses
      elsif model.is_a?(IpAddress)
        [model]
      else
        model
      end
    end

    def find_model(string)
      type, resource = ResourceParser.call(string)

      case type
      when :ip
        IpAddress.find_by!(address: resource)
      when :domain
        Domain.find_by!(name: resource)
      else
        {
          errors: [{title: 'Input format is not valid', status: STATUS_PARAMETER_ERROR} ]
        }
      end
    end
  end
end
