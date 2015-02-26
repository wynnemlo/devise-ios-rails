def stub_successful_facebook_request
  stub_request(
    :get,
    "https://graph.facebook.com/me?access_token=valid_token"
  ).to_return(
    :status => 200,
    :body => '',
    :headers => {}
  )
end

def stub_unsuccessful_facebook_request
  stub_request(
    :get,
    "https://graph.facebook.com/me?access_token=invalid_token"
  ).to_return(
    :status => 400,
    :body => '{
      "error": {
        "message": "Error message.",
        "type": "OAuthException",
        "code": 190,
        "error_subcode": 463
      }
    }',
    :headers => {}
  )
end
