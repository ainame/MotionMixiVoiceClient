class MixiAuthorizationController < UIViewController
  attr_reader :api_client

  def viewDidAppear(animated)
    super
    @web_view = UIWebView.alloc.init.tap do |w|
      w.frame = self.view.bounds
      w.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
      
      w.scalesPageToFit = true
      w.delegate = self
    end
    self.view.addSubview @web_view

    @api_client ||= MixiGraphAPI.new
    url = NSURL.URLWithString(@api_client.authorization_url)
    request = NSURLRequest.requestWithURL(url)
    @web_view.loadRequest request
  end

  def webViewDidFinishLoad(web_view)
    url = NSURL.URLWithString(
      web_view.stringByEvaluatingJavaScriptFromString("document.URL")
    )

    if url && url.query
      params_array = url.query.split('&')
      params = params_array.map do |param_set|
        key, value = param_set.split('=')
        {key => value}
      end.inject(:merge)

      if params['code'] =~ /^\w+$/ &&
          @api_client.access_token.nil?
        @api_client.get_access_token(params['code'])
        App.shared.delegate.api_client = @api_client
        self.dismissModalViewControllerAnimated(true)
      end
    end
  end

end
