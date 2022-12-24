# frozen_string_literal: true

require 'rails_helper'

describe 'Minimum Bids' do
  describe 'GET /api/v1/bids' do
    before do
      create(:bid, country: 'us', category: 'finance', channel: 'ca', amount: 4.0)
      create(:bid, country: 'uk', category: 'sports', channel: '*', amount: 3.0)
      create(:bid, country: 'us', category: '*', channel: '*', amount: 2.0)
      create(:bid, country: '*', category: '*', channel: '*', amount: 1.0)
    end

    it 'returns the minimum bids for each combination' do
      get '/api/v1/bids', params: { countries: 'us,uk', categories: 'finance,sports', channels: 'ca,ga' }

      expect(response).to have_http_status(:ok)

      bids_response = json_response['bids']
      expect(bids_response).to match_array(
        [
          { 'country' => 'us', 'category' => 'finance', 'channel' => 'ca', 'amount' => '4.0' },
          { 'country' => 'us', 'category' => 'finance', 'channel' => 'ga', 'amount' => '2.0' },
          { 'country' => 'us', 'category' => 'sports', 'channel' => 'ca', 'amount' => '2.0' },
          { 'country' => 'us', 'category' => 'sports', 'channel' => 'ga', 'amount' => '2.0' },
          { 'country' => 'uk', 'category' => 'finance', 'channel' => 'ca', 'amount' => '1.0' },
          { 'country' => 'uk', 'category' => 'finance', 'channel' => 'ga', 'amount' => '1.0' },
          { 'country' => 'uk', 'category' => 'sports', 'channel' => 'ca', 'amount' => '3.0' },
          { 'country' => 'uk', 'category' => 'sports', 'channel' => 'ga', 'amount' => '3.0' }
        ]
      )
    end

    it 'returns bids from all(*) when country is not present' do
      get '/api/v1/bids', params: { countries: 'ja', categories: 'sports', channels: 'sa' }
      expect(response).to have_http_status(:ok)

      bids_response = json_response['bids']
      expect(bids_response).to match_array(
        [
          { 'country' => 'ja', 'category' => 'sports', 'channel' => 'sa', 'amount' => '1.0' }
        ]
      )
    end

    context 'when invalid params are provided' do
      it 'returns blank data' do
        get '/api/v1/bids', params: { countries: '', categories: 'finance,sports', channels: 'ca,ga' }
        expect(response).to have_http_status(:ok)
        bids_response = json_response['bids']
        expect(bids_response).to be_blank
      end
    end
  end
end
