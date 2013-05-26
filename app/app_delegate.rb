class AppDelegate
  attr_accessor :api_client

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @api_client = MixiGraphAPI.new
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds).tap do |w|
      voice_list_controller = MixiVoiceListController.alloc.init
      navigation_controller = MixiVoiceNavigationController.alloc.
        initWithRootViewController(voice_list_controller)
      w.rootViewController = navigation_controller

      w.makeKeyAndVisible
    end
  end
end
