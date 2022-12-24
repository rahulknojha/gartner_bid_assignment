# frozen_string_literal: true

module Api
  module V1
    class BidsController < ApplicationController
      def index
        bids = ::V1::Bids::Index.new(**index_params).call
        render json: { bids: bids }
      end

      private

      def index_params
        params.permit(%i[countries categories channels]).to_hash.symbolize_keys
      end
    end
  end
end
