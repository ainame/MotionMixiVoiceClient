class MixiVoiceDetailController < UIViewController

  def initWithCell(cell)
    @cell = cell
    init
  end

  def viewDidLoad
    super
    @label = UILabel.alloc.initWithFrame(CGRectZero)
    @label.text = @cell['text']
    @label.sizeToFit
    @label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
    self.view.addSubview @label
    self.view.backgroundColor = UIColor.whiteColor
  end

end
