class AppDelegate
  attr_accessor :api_client

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds).tap do |w|
      voice_list_controller = MixiVoiceListController.alloc.init
      w.rootViewController  = MixiVoiceNavigationController.alloc.
        initWithRootViewController(voice_list_controller)
      w.makeKeyAndVisible
    end
  end
end
