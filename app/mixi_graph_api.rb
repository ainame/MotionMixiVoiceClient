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

  def get_access_token(code, &block)
    body = {
      grant_type: "authorization_code",
      client_id: CONSUMER_KEY,
      client_secret: CONSUMER_SECRET,
      code: code,
      redirect_uri: REDIRECT_URI
    }
    request_token_url(body, &block)
  end

  def refresh_access_token(refresh_token, &block)
    body = {
      grant_type: "refresh_token",
      client_id: CONSUMER_KEY,
      client_secret: CONSUMER_SECRET,
      refresh_token: refresh_token,
    }
    request_token_url(body, &block)
  end

  def request_token_url(body, &block)
    BW::HTTP.post(TOKEN_URL, {payload: body}) do |response|
      if json = BW::JSON.parse(response.body.to_s)
        @access_token = json["access_token"]
        @refresh_token = json["refresh_token"]
      end
      block.call
    end
  end

  def request(verb, endpoint, params, &block)
    params.merge!({headers: { "Authorization" => "Bearer #{@access_token}"}})
    BW::HTTP.__send__(verb, API_BASE_URL + endpoint, params, &block )
  end

  def friends_timeline(params = {}, &block)
    request(:get, '/voice/statuses/friends_timeline',
      params,  &block)
  end

  def update_tweet(body)
    params = { payload: { status: body } }
    request(:post, '/voice/statuses', params) do |response|
      p response if response
    end
  end

  private
  def session_id
    SESSION_ID
  end

end
