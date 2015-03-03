require 'rails_helper'

describe OauthTokenValidator do
  let(:facebook_url) do
    'https://graph.facebook.com/me?access_token=valid_token'
  end

  context 'connection timeout' do
    it 'adds error on oauth_token' do
      stub_request(:any, facebook_url).to_timeout
      user = build :oauth_user
      expect(user).not_to be_valid
      expect(user.errors[:oauth_token].size).to eq(1)
    end
  end

  context 'no connection' do
    it 'adds error on oauth_token' do
      stub_request(:any, facebook_url).to_raise(Faraday::ConnectionFailed)
      user = build :oauth_user
      expect(user).not_to be_valid
      expect(user.errors[:oauth_token].size).to eq(1)
    end
  end
end
