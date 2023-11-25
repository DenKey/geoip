# frozen_string_literal: true

module Geolocation
  class ResourceParser
    class << self
      # The most powerful regexp that I found in https://regexr.com/38p9g
      URL_REGEXP = /((?:(?:http(s)?):\/\/)?(?:(?:www)\.)?((?:((?:[!$&-;=?-\[_a-z~\]]|(?:\%[0-9A-Fa-f]{2}))+)\.)?((?:[!$&-.0-;=?-\[_a-z~\]]|(?:\%[0-9A-Fa-f]{2}))*)\.(:?[A-Za-z]{2,5}))(?:(?:\/((?:[!$&-;=@-\[_a-z~\]]|(?:\%[0-9A-Fa-f]{2}))*))?(?:(?:\?)((?:[!$&-;=@-\[_a-z~\]]|(?:\%[0-9A-Fa-f]{2}))*=(?:[!$&-;=@-\[_a-z~\]]|(?:\%[0-9A-Fa-f]{2}))*))?(#(?:[!$&-;=?-\[_a-z~\]]|(?:\%[0-9A-Fa-f]{2}))*)?)?)/i

      def call(string)
        return [:ip, ip(string)] if valid_ip_addr?(string)
        return [:domain, domain(string)] if valid_url?(string)

        [:error, nil]
      end

      private

      def valid_ip_addr?(string)
        IPAddr.new(string)
        true
      rescue IPAddr::InvalidAddressError, IPAddr::AddressFamilyError => _error
        false
      end

      def valid_url?(url)
        return false if url.nil? || url.empty?
        url =~ URL_REGEXP ? true : false
      end

      def domain(string)
        string.match(URL_REGEXP)[3]
      end

      def ip(string)
        IPAddr.new(string)
      end
    end
  end
end
