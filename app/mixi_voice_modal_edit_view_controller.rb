# -*- coding: utf-8 -*-
class MixiVoiceModalEditViewController < UIViewController
  def viewDidLoad
    super
    @edit_view = make_edit_view
    self.navigationItem.title = "つぶやき入力" 
    self.navigationItem.rightBarButtonItem = 
      UIBarButtonItem.alloc.initWithBarButtonSystemItem(
        UIBarButtonSystemItemDone,
        target: self, action: 'clickDoneButton'
      )
    self.view.addSubview @edit_view
  end

  def clickDoneButton
    if @edit_view.hasText
      p @edit_view.text
      App.shared.delegate.api_client.
        update_tweet(@edit_view.text)
    end
    self.dismissModalViewControllerAnimated(true)
  end

  private
  def make_edit_view
    UITextView.alloc.init.tap do |v|
      v.frame = self.view.bounds
      v.backgroundColor = UIColor.whiteColor
      v.font = UIFont.systemFontOfSize 16
    end    
  end

end
