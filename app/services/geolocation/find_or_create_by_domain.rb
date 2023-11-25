# frozen_string_literal: true

module Geolocation
  class FindOrCreateByDomain < BaseGeodata
    def initialize(provider)
      @provider = provider
    end

    def call(domain)
      domain_record = Domain.find_by(name: domain)

      # TODO: We can check new ip for domain each time and add it to list if its new
      if domain_record
        domain_record.ip_addresses
      else
        data = @provider.call(domain)

        errors = validate_data(data)
        return errors if errors

        create_records!(data, domain)
      end
    rescue ActiveRecord::ActiveRecordError => _e
      activerecord_error
    end

    private

    def create_records!(data, domain)
      ActiveRecord::Base.transaction do
        ip_record = IpAddress.create!(
          address: data[:ip],
          ip_type: :ipv4,
          coordinate: ActiveRecord::Point.new(data[:longitude], data[:latitude])
        )

        Domain.create!(
          name: domain,
          ip_addresses: [ip_record]
        )

        [ip_record]
      end
    end
  end
end
