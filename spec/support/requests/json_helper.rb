# frozen_string_literal: true

module Requests
  # This module is responsible for parsing response
  module JsonHelpers
    def json_response
      @json_response ||= JSON.parse(response.body)
    end
  end
end
