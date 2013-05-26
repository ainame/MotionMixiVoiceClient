# -*- coding: utf-8 -*-
class MixiVoiceListController < UITableViewController
  include MixiVoiceListView
  CELL_IDENTIFIER = "cell"

  def viewDidLoad
    super
    assign_ui_parts
    @tweets = []
  end

  def viewDidAppear(animated)
    unless refresh_token = App::Persistence['refresh_token']
      authorization_contorlller = MixiAuthorizationController.new
      authorization_contorlller.on_modal_close do
        update_tweet_list
      end

      self.presentModalViewController(       
        authorization_contorlller,
        animated: true      
      )
    else
      update_tweet_list
    end
  end

  def tableView(table, numberOfRowsInSection:section)
    @tweets.size
  end

  def tableView(table, cellForRowAtIndexPath:indexPath)
    cell = table.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER) ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: CELL_IDENTIFIER)
    cell.textLabel.text = @tweets[indexPath.row]['text']
    cell
  end

  def tableView(table, didSelectRowAtIndexPath:indexPath)
    cell = @tweets[indexPath.row]
    cnt = MixiVoiceDetailController.alloc.initWithCell(cell)
    self.navigationController.pushViewController(
      cnt, animated: true
    )
  end

  def clickEditButton
    self.presentModalViewController(
      mixi_voice_modal_edit_view_controller,
      animated: true      
    )
  end

  def clickRefreshButton
    update_tweet_list
  end

  private
  def update_tweet_list
    App.shared.delegate.api_client.
      refresh_access_token(App::Persistence['refresh_token']) do
      fetch_tweets
      updateViewConstraints
    end
  end

  def mixi_voice_modal_edit_view_controller
    UINavigationController.alloc.initWithRootViewController(
      MixiVoiceModalEditViewController.alloc.init
    )
  end

  def assign_table_cells(entries)
    unless entries && entries.empty?
      @tweets.concat(entries)
      self.tableView.reloadData
    end
  end

  def fetch_tweets
    if client = App.shared.delegate.api_client
      client.friends_timeline do |response|
        if response.ok?
          entries = BW::JSON.parse(response.body.to_s)
          unless entries && entries.empty?
            assign_table_cells(entries)
          end
        end
      end
    end
  end

end
