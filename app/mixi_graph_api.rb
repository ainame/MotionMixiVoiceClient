class MixiGraphAPI
  attr_reader *[
    :consumer_key, :consumer_secret, :scope,
    :access_token, :refresh_token
  ]

  CONSUMER_KEY = "xxxxxxxxxxxxxxxxxxxxxxxxx"
  CONSUMER_SECRET = "xxxxxxxxxxxxxxxxxxxx"
  API_BASE_URL = "https://api.mixi-platform.com/2"
  TOKEN_URL = "https://secure.mixi-platform.com/2/token"
  REDIRECT_URI = "http://mixi.jp"
  CONNECT_AUTHORIZE_URL = "https://mixi.jp/connect_authorize.pl"
  SESSION_ID = 1

  def initialize
    @consumer_key = CONSUMER_KEY
    @consumer_secret = CONSUMER_SECRET
    @scope = "r_profile r_voice w_voice"
  end

  def authorization_url
    query = {
      client_id: CONSUMER_KEY,
      response_type: 'code',
      scope: @scope,
      display: 'smartphone',
      state: session_id
    }.map{|k,v| "#{k}=#{v}"}.join('&')
    escaped_query = query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
    CONNECT_AUTHORIZE_URL + '?' + escaped_query
  end

  def get_access_token(code)
    body = {
      grant_type: "authorization_code",
      client_id: CONSUMER_KEY,
      client_secret: CONSUMER_SECRET,
      code: code,
      redirect_uri: REDIRECT_URI
    }

    BW::HTTP.post(TOKEN_URL, {payload: body}) do |response|
      if response.ok?
        json = BW::JSON.parse(response.body.to_s)
        if json
          @access_token = json["access_token"]
          @refresh_token = json["refresh_token"]
        end
      end
    end
  end
  
  def update_tweet(body)
    options = {
      headers: {
        "Authorization" => "Bearer #{@access_token}",
        #'Content-Type' => 'application/x-www-form-urlencoded'
      },
      payload: { status: body },
    }
    BW::HTTP.post(API_BASE_URL + '/voice/statuses',
      options
    ) do |response|
      p response.body if response
    end
  end

  private
  def session_id
    SESSION_ID
  end

end
