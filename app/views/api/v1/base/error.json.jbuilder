# frozen_string_literal: true

json.errors @errors do |error|
  json.status error[:status]
  json.title error[:title]
end
