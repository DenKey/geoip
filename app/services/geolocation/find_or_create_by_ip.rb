# frozen_string_literal: true

module Geolocation
  class FindOrCreateByIp < BaseGeodata
    def initialize(provider)
      @provider = provider
    end

    def call(address)
      ip_record = IpAddress.find_by(address: address)

      unless ip_record
        data = @provider.call(address)

        errors = validate_data(data)
        return errors if errors

        return create_records!(data, address)
      end

      [ip_record]
    rescue ActiveRecord::ActiveRecordError => _e
      activerecord_error
    end

    private

    def create_records!(data, address)
      ip_record = IpAddress.create!(
        address: address,
        ip_type: :ipv4,
        coordinate: ActiveRecord::Point.new(data[:longitude], data[:latitude])
      )

      [ip_record]
    end
  end
end
