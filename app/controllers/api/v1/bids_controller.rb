class Api::V1::BidsController < ApplicationController

	def index
		bids = V1::Bids::Index.new(**index_params).call
		render json: { bids: bids }
	end


	private

	def index_params
		params.permit([:countries, :categories, :channels]).to_hash.symbolize_keys
	end
end