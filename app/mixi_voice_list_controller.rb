# -*- coding: utf-8 -*-
class MixiVoiceListController < UITableViewController
  CELL_IDENTIFIER = "cell"

  def viewDidLoad
    super
    self.title = "つぶやきクライアント"
    self.navigationItem.rightBarButtonItem = 
      UIBarButtonItem.alloc.initWithBarButtonSystemItem(
        UIBarButtonSystemItemCompose,
        target: self, action: 'clickEditButton'
      )
    @tweets = ['vol', 'ボル', 'JK']

    self.presentModalViewController(
      mixi_authorization_controller,
      animated: true      
    )
  end

  def tableView(table, numberOfRowsInSection:section)
    @tweets.size
  end

  def tableView(table, cellForRowAtIndexPath:indexPath)
    cell = table.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER) ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: CELL_IDENTIFIER)
    cell.textLabel.text = @tweets[indexPath.row]
    cell
  end

  def clickEditButton
    self.presentModalViewController(
      mixi_voice_modal_edit_view_controller,
      animated: true      
    )
  end

  private
  def mixi_authorization_controller
    MixiAuthorizationController.alloc.init
  end

  def mixi_voice_modal_edit_view_controller
    UINavigationController.alloc.initWithRootViewController(
      MixiVoiceModalEditViewController.alloc.init
    )
  end

end
