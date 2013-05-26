class MixiAuthorizationController < UIViewController
  attr_reader :api_client

  def viewDidAppear(animated)
    super
    return unless App::Persistence['refresh_token'].nil?
    @already_authorized = false

    @web_view = UIWebView.alloc.init.tap do |w|
      w.frame = self.view.bounds
      w.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
      
      w.scalesPageToFit = true
      w.delegate = self
    end
    self.view.addSubview(@web_view)

    @api_client ||= MixiGraphAPI.new
    url = NSURL.URLWithString(@api_client.authorization_url)
    request = NSURLRequest.requestWithURL(url)
    @web_view.loadRequest(request)
  end

  def webViewDidFinishLoad(webView)
    url = NSURL.URLWithString(
      webView.stringByEvaluatingJavaScriptFromString("document.URL")
    )
    return if @already_authorized
    return unless url && url.query && url.query =~ /code=\w*/

    @api_client.get_access_token(get_code(url)) do
      App.shared.delegate.api_client = @api_client
      App::Persistence['refresh_token'] = @api_client.refresh_token
    end

    @already_authorized = true
    self.dismissModalViewControllerAnimated(true)
    @callback_on_modal_close.call
  end

  def on_modal_close(&block)
    @callback_on_modal_close = block
  end

  private
  def get_code(url)
    params_array = url.query.split('&')
    params = params_array.map do |param_set|
      key, value = param_set.split('=')
      {key => value}
    end.inject(:merge)

    params['code']
  end

end
