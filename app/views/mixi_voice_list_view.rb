# -*- coding: utf-8 -*-
module MixiVoiceListView
  def assign_ui_parts
    self.title = "つぶやきクライアント"
    self.navigationItem.rightBarButtonItem = 
      UIBarButtonItem.alloc.initWithBarButtonSystemItem(
        UIBarButtonSystemItemCompose,
        target: self, action: 'clickEditButton'
      )
    self.navigationItem.leftBarButtonItem = 
      UIBarButtonItem.alloc.initWithBarButtonSystemItem(
        UIBarButtonSystemItemRefresh,
        target: self, action: 'clickRefreshButton'
      )
  end
end
