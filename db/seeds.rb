# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

data = [
  {
    ip: '172.253.63.113',
    domain: 'google.com',
    coordinate: [-122.07540893554688, 37.419158935546875]
  },
  {
    ip: '74.6.231.20',
    domain: 'yahoo.com',
    coordinate: [-73.9884033203125, 40.73139190673828]
  },
  {
    ip: '204.79.197.200',
    domain: 'bing.com',
    coordinate: [-122.12094116210938, 47.68050003051758]
  },
  {
    ip: '208.80.154.224',
    domain: 'wikipedia.org',
    coordinate: [-77.38275909423828, 38.98371887207031]
  },
  {
    ip: '52.94.236.248',
    domain: 'amazon.com',
    coordinate: [-77.47419738769531, 39.043701171875]
  },
  {
    ip: '93.184.216.34',
    domain: 'example.com',
    coordinate: [-88.0197982788086, 41.877628326416016]
  },
  {
    ip: '34.98.86.237',
    domain: 'deal.com',
    coordinate: [-94.53961181640625, 39.10771179199219]
  },
  {
    ip: '161.170.244.20',
    domain: 'wallmart.com',
    coordinate: [-94.24714660644531, 36.343109130859375]
  },
  {
    ip: '52.14.144.171',
    domain: 'cocacola.com',
    coordinate: [-82.99945831298828, 39.99557876586914]
  },
  {
    ip: '35.203.23.79',
    domain: 'positrace.com',
    coordinate: [-73.56999969482422, 45.52000045776367]
  }
]

puts 'Creating seed data started'

data.each do |record|
  ip = IpAddress.create(
    address: IPAddr.new(record[:ip]),
    ip_type: :ipv4,
    coordinate: ActiveRecord::Point.new(record[:coordinate][0], record[:coordinate][1])
  )

  Domain.create(
    name: record[:domain],
    ip_addresses: [ip]
  )
end

puts 'Creating seed data finished'
