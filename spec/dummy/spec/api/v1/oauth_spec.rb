require 'rails_helper'

describe 'OAuth' do
  include Rack::Test::Methods
  include_context 'format: json'

  describe 'user registration' do
    context 'with valid oauth_token' do
      let(:params) do
        {
          user: {
            provider: 'facebook',
            oauth_token: 'valid_token',
            uid: '1234'
          }
        }
      end

      before { stub_successful_facebook_request }

      it 'creates a new user' do
        expect do
          post 'v1/auth/facebook', params
        end.to change(User, :count).by(1)
      end

      context 'with existing provider and uid' do
        let!(:user) { create(:oauth_user) }

        it 'returns the existing user' do
          expect do
            post 'v1/auth/facebook', user: user.attributes
          end.not_to change(User, :count)
        end
      end
    end

    context 'with invalid oauth_token' do
      before { stub_unsuccessful_facebook_request }

      it 'responds with error message' do
        user = build(:oauth_user, oauth_token: 'invalid_token')
        expect(
          post('v1/auth/facebook', user: user.attributes).body
        ).to include 'Error message.'
      end
    end
  end
end
