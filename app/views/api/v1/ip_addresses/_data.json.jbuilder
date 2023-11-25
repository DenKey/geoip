# frozen_string_literal: true

json.data data do |ip_address|
  json.type 'ip_address'
  json.id ip_address.id
  json.attributes do
    json.ip_address ip_address.address
    json.longitude ip_address.coordinate.x
    json.latitude ip_address.coordinate.y
  end
end
