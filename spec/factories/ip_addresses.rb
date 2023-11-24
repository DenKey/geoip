FactoryBot.define do
  factory :ip_address do
    address { IPAddr.new('172.253.63.113') }
    ip_type { 0 }
    coordinate { ActiveRecord::Point.new(-122.07540893554688, 37.419158935546875) }
  end
end
