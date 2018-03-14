//
//  TEToastView.swift
//  TEToastView
//
//  Created with ❤️ by Tatevik Tovmasyan on 2/19/18.
//  Copyright © 2018 Tatevik Tovmasyan. All rights reserved.
//

import Foundation
import UIKit

class TEToastView: UIView {
    
    // position can be either on top, on bottom or on center ... default value is center
    
    enum Position {
        case top
        case center
        case bottom
    }
    
    fileprivate enum Size {
        case large
        case medium
        case small
        case noText
    }
    
    fileprivate enum LabelType {
        case title
        case comment
    }
    
    fileprivate var viewWidth: CGFloat = 200.0
    fileprivate var viewHeight: CGFloat = 200.0
    
    fileprivate var titleLabelHeight: CGFloat!
    fileprivate var commentLabelHeight: CGFloat!
    
    fileprivate weak var superView: UIView!
    
    fileprivate var imageView: UIImageView?
    fileprivate var titleLabel: UILabel?
    fileprivate var commentLabel: UILabel?
    
    fileprivate var isCommentLabelMultiline: Bool? = false
    fileprivate var invisibleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    fileprivate var size: Size = .large
    
    fileprivate var onlyLabelType: LabelType?
    
    //Changeable values
    public var title: String?
    public var image: UIImage?
    public var comment: String?
    
    public var position: Position = .center
    
    public var titleFont: UIFont = UIFont(name: "American Typewriter", size: 15.0)!
    public var commentFont: UIFont = UIFont(name: "American Typewriter", size: 11.0)!
    
    public var animDuration: TimeInterval = 0.25
    public var imageSize: CGSize = CGSize(width: 50.0, height: 50.0)
    
    public var trailingAndLeadingConstraint: CGFloat = 8.0
    public var topAndBottomConstraint: CGFloat = 8.0
    
    public var screenPercentToCover: CGFloat = 0.8
    
    public var topDistanceFromSuperView: CGFloat = 20.0
    public var bottomDistanceFromSuperview: CGFloat = 30.0
    
    public var titleColor: UIColor = UIColor(netHex: 0x4E4E4E)
    public var commentColor: UIColor = UIColor(netHex: 0xC4C4C4)
    public var backColor: UIColor = UIColor(netHex: 0xF3F3F3)
    
    public var cornerRadius: CGFloat = 0.0
    
    public var layerShadowColor: UIColor = UIColor(red: 0.31, green: 0.31, blue: 0.31, alpha: 1)
    
    init(title: String? = nil, comment: String? = nil, image: UIImage? = nil) {
        
        self.title = title
        self.image = image
        self.comment = comment
        
        // Initializes SIZE
        if title == nil && comment == nil && image != nil {
            self.size = .noText
        } else if (title == nil && comment != nil) || (title != nil && comment == nil) {
            self.size = .small
            if title == nil {
                onlyLabelType = .comment
            } else {
                onlyLabelType = .title
            }
        } else if (image == nil && title != nil && comment != nil) {
            self.size = .medium
        } else if (image != nil && title != nil && comment != nil) {
            self.size = .large
        }
        
        super.init(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
        
        self.alpha = 0.0
        
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented, plese use designated init")
    }
    
    fileprivate func applyLayerAppearance() {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 6
        self.layer.shadowColor = self.layerShadowColor.cgColor
        self.layer.shadowOpacity = 0.3
    }
    
    //MARK: Appearance
    fileprivate func addImageView() {
        switch size {
        case .large, .small:
            if self.position != .center {
                imageView = UIImageView(frame: CGRect(x: trailingAndLeadingConstraint, y: self.frame.size.height/2 - imageSize.height/2, width: imageSize.width, height: imageSize.height))
            } else {
                imageView = UIImageView(frame: CGRect(x: self.frame.size.width/2 - imageSize.width/2, y: topAndBottomConstraint, width: imageSize.width, height: imageSize.height))
            }
        case .medium:
            break
        case .noText:
            imageView = UIImageView(frame: CGRect(x: trailingAndLeadingConstraint, y: topAndBottomConstraint, width: self.frame.size.width - 2*trailingAndLeadingConstraint, height: self.frame.size.height - 2*topAndBottomConstraint))
        }
        
        imageView?.image = image
        imageView?.contentMode = .scaleAspectFit
        self.addSubview(imageView!)
    }
    
    fileprivate func addTitleLabel() {
        
        switch size {
        case .large:
            let height: CGFloat = self.position == .center ? imageSize.height : 0.0
            let width: CGFloat = self.position != .center ? imageSize.width : 0.0
            
            var imageOriginY: CGFloat = 0.0
            var imageOriginX: CGFloat = 0.0
            
            if let originY = self.imageView?.frame.origin.y, let originX = self.imageView?.frame.origin.x {
                imageOriginY = self.position == .center ? originY : 0.0
                imageOriginX = self.position != .center ? originX : 0.0
            }
            
            commentLabelHeight = self.comment == nil ? 0 : commentLabelHeight
            
            var labelOriginY = self.position != .center ? self.frame.size.height/2 - (titleLabelHeight + topAndBottomConstraint + commentLabelHeight)/2 : imageOriginY + height + topAndBottomConstraint
            
            labelOriginY = labelOriginY < topAndBottomConstraint ? topAndBottomConstraint : labelOriginY
            
            let  labelOriginX = trailingAndLeadingConstraint + width + imageOriginX
            
            titleLabel = UILabel(frame: CGRect(x: labelOriginX, y: labelOriginY, width: self.frame.size.width - labelOriginX - trailingAndLeadingConstraint, height: titleLabelHeight))
        case .medium:
            titleLabel = UILabel(frame: CGRect(x: trailingAndLeadingConstraint, y: topAndBottomConstraint, width: self.frame.width - trailingAndLeadingConstraint*2, height: titleLabelHeight))
        case .small:
            if self.image != nil {
                let originX = self.position == .center ? trailingAndLeadingConstraint : imageSize.width + trailingAndLeadingConstraint * 2
                let originY = self.position == .center ? imageSize.height + topAndBottomConstraint * 2 : self.frame.size.height/2 - titleLabelHeight/2
                let labelWidth = self.position == .center ? self.frame.width - trailingAndLeadingConstraint * 2 : self.frame.width - imageSize.width - 3 * trailingAndLeadingConstraint
                titleLabel = UILabel(frame: CGRect(x: originX, y: originY, width: labelWidth, height: titleLabelHeight))
            } else {
                titleLabel = UILabel(frame: CGRect(x: trailingAndLeadingConstraint, y: self.frame.size.height/2 - titleLabelHeight/2, width: self.frame.width - trailingAndLeadingConstraint*2, height: titleLabelHeight))
            }
        case .noText:
            break
        }
        
        if self.size != .noText {
            titleLabel?.text = self.title
            titleLabel?.textAlignment = .center
            titleLabel?.adjustsFontSizeToFitWidth = true
            titleLabel?.font = self.titleFont
            titleLabel?.textColor = self.titleColor
            self.addSubview(titleLabel!)
        }
    }
    
    fileprivate func addCommentLabel() {
        
        switch size {
        case .large, .medium:
            if let titleOriginX = self.titleLabel?.frame.origin.x, let titleOriginY = self.titleLabel?.frame.origin.y, let width = self.titleLabel?.frame.size.width {
                commentLabel = UILabel(frame: CGRect(x: titleOriginX, y: titleOriginY + titleLabelHeight + topAndBottomConstraint, width: width, height: commentLabelHeight))
            }
        case .small:
            if self.image != nil {
                if position == .center {
                    commentLabel = UILabel(frame: CGRect(x: trailingAndLeadingConstraint, y: imageSize.height + 2 * topAndBottomConstraint, width: self.frame.width - trailingAndLeadingConstraint*2, height: commentLabelHeight))
                } else {
                    commentLabel = UILabel(frame: CGRect(x: 2 * trailingAndLeadingConstraint + imageSize.width, y: self.frame.size.height / 2 - commentLabelHeight/2, width: self.frame.width - trailingAndLeadingConstraint*3 - imageSize.width, height: commentLabelHeight))
                }
            } else {
                commentLabel = UILabel(frame: CGRect(x: trailingAndLeadingConstraint, y: self.frame.size.height / 2 - commentLabelHeight/2, width: self.frame.width - trailingAndLeadingConstraint*2, height: commentLabelHeight))
            }
        case .noText:
            break
        }
        
        if self.size != .noText {
            commentLabel?.textAlignment = .center
            commentLabel?.text = comment
            commentLabel?.lineBreakMode = .byWordWrapping
            commentLabel?.numberOfLines = 0
            commentLabel?.font = self.commentFont
            commentLabel?.textColor = self.commentColor
            self.addSubview(commentLabel!)
        }
    }
    
    // Support for Safe Area Layout
    
    override func layoutSubviews() {
        if #available(iOS 11, *) {
            let insets = superView.safeAreaInsets
            
            if insets.top > 0 && position == .top {
                self.frame.origin.y = insets.top + self.topDistanceFromSuperView
            }
            
            if insets.bottom > 0, position == .bottom {
                self.bottomDistanceFromSuperview += insets.bottom
                self.frame.origin.y = UIScreen.main.bounds.height - self.bottomDistanceFromSuperview - self.frame.size.height
            }
        } else {
            if position == .top {
                self.frame.origin.y = self.topDistanceFromSuperView
            } else if position == .bottom {
                self.frame.origin.y = UIScreen.main.bounds.height - self.frame.size.height - self.bottomDistanceFromSuperview
            }
        }
    }
    
    func frameForView(inSuperview superView: UIView, completion: (()->Void)? = nil) {
        
        self.commentLabelHeight = self.commentFont.lineHeight
        self.titleLabelHeight = self.titleFont.lineHeight
        
        //Initializes VIEWWIDTH
        
        self.imageSize = self.image == nil ? CGSize(width: 0, height: 0) : self.imageSize
        
        let distancesWidth = self.position == .center ? 2*trailingAndLeadingConstraint : 3*trailingAndLeadingConstraint
        
        if self.imageSize.width + 2*trailingAndLeadingConstraint > superView.frame.size.width * self.screenPercentToCover {
            self.imageSize.width = superView.frame.size.width * self.screenPercentToCover - 2*trailingAndLeadingConstraint
        }
        
        switch size {
        case .small:
            let text = onlyLabelType == .title ? self.title : self.comment
            let textFont = onlyLabelType == .title ? self.titleFont : self.commentFont
            
            invisibleLabel.text = text
            invisibleLabel.font = textFont
            
            let expectedImageWidth = self.position == .center ? 0 : imageSize.width
            
            if image != nil {
                viewWidth = expectedImageWidth + distancesWidth + invisibleLabel.intrinsicContentSize.width
            } else {
                viewWidth = 2*trailingAndLeadingConstraint + invisibleLabel.intrinsicContentSize.width
            }
        case .noText:
            break
        default:
            // we have both commentLabel and titleLabel
            if let commentText = comment, let titleText = title {
                if commentText.count > titleText.count {
                    invisibleLabel.text = commentText
                    invisibleLabel.font = commentFont
                } else {
                    invisibleLabel.text = titleText
                    invisibleLabel.font = titleFont
                }
                var expectedImageWidth = self.position == .center ? 0 : imageSize.width
                if image == nil {
                    expectedImageWidth = 0
                }
                viewWidth = invisibleLabel.intrinsicContentSize.width + distancesWidth + expectedImageWidth
                
                if imageSize.width + 2*trailingAndLeadingConstraint > viewWidth {
                    viewWidth = imageSize.width + 2*trailingAndLeadingConstraint
                }
            }
        }
        
        if viewWidth > UIScreen.main.bounds.width * screenPercentToCover {
            viewWidth = UIScreen.main.bounds.width * screenPercentToCover
        } else if viewWidth < 100.0 {
            viewWidth = 100.0
        }
        
        //Initializes COMMENTLABELHEIGHT
        if let commentText = comment {
            self.invisibleLabel.text = commentText
            self.invisibleLabel.font = self.commentFont
            
            let expectedImageWidth = self.position == .center ? 0 : imageSize.width
            
            if invisibleLabel.intrinsicContentSize.width + distancesWidth + expectedImageWidth > viewWidth {
                isCommentLabelMultiline = true
                let lineCount = ceil(Double((self.invisibleLabel.intrinsicContentSize.width + invisibleLabel.layoutMargins.left + invisibleLabel.layoutMargins.right)/(viewWidth - expectedImageWidth - distancesWidth)))
                
                commentLabelHeight = CGFloat((lineCount + 1)) * commentFont.lineHeight + self.invisibleLabel.layoutMargins.bottom + self.invisibleLabel.layoutMargins.top
            }
        }
        
        //initializes VIEWHEIGHT
        switch size {
        case .large:
            var distanceHeight = position == .center ? 4 * trailingAndLeadingConstraint : 3 * trailingAndLeadingConstraint
            
            if self.imageSize.height > titleLabelHeight + commentLabelHeight + distanceHeight && position != .center {
                distanceHeight = 2*trailingAndLeadingConstraint
            }
            
            let maxHeight = self.imageSize.height > titleLabelHeight + commentLabelHeight + distanceHeight ? self.imageSize.height : titleLabelHeight + commentLabelHeight + distanceHeight
            
            if self.position != .center {
                self.viewHeight = distanceHeight + maxHeight
            } else {
                self.viewHeight = distanceHeight + titleLabelHeight + commentLabelHeight + self.imageSize.height
            }
        case .medium:
            self.viewHeight = 3 * trailingAndLeadingConstraint + titleLabelHeight + commentLabelHeight
        case .small:
            var appendingDist: CGFloat = 2 * topAndBottomConstraint
            if image != nil && position == .center {
                appendingDist = 3 * trailingAndLeadingConstraint
            }
            var labelHeight = comment == nil ? titleLabelHeight : commentLabelHeight
            
            if self.position != .center && self.image != nil {
                labelHeight = 0
            }
            
            self.viewHeight = appendingDist + labelHeight! + imageSize.height
        case .noText:
            self.viewHeight = self.imageSize.height + 2*trailingAndLeadingConstraint
            self.viewWidth = self.imageSize.width + 2*trailingAndLeadingConstraint
        }
        
        if self.viewHeight < self.imageSize.height + 2*trailingAndLeadingConstraint {
            self.viewHeight = self.imageSize.height + 2*trailingAndLeadingConstraint
        }
        
        var positionY: CGFloat = 0.0
        
        // IF HEIGHT > WIDTH
        if viewHeight > viewWidth && position == .center && viewHeight < superView.frame.size.width * screenPercentToCover {
            viewWidth = viewHeight
        }
        
        switch position {
        case .center:
            positionY = superView.frame.size.height/2 - viewHeight/2
        case .top:
            positionY = superView.frame.origin.y + topDistanceFromSuperView
        case .bottom:
            positionY = superView.bounds.size.height - viewHeight - bottomDistanceFromSuperview
        }
        
        self.frame = CGRect(x: UIScreen.main.bounds.size.width/2 - viewWidth/2,
                            y: positionY,
                            width: viewWidth,
                            height: viewHeight)
        
        completion!()
    }
    
    func updateSubviews() {
        if image != nil {
            self.addImageView()
        }
        
        if title != nil {
            self.addTitleLabel()
        }
        
        if comment != nil {
            self.addCommentLabel()
        }
    }
}

//MARK: Displaying
extension TEToastView {
    func present(inSuperview superview: UIView? = UIApplication.shared.keyWindow, hideAfter delay: TimeInterval? = 4, animated: Bool? = true, completion: (()->Void)? = nil) {
        
        self.backgroundColor = self.backColor
        self.applyLayerAppearance()
        
        self.superView = superview
        self.frameForView(inSuperview: superview!, completion: {
            self.updateSubviews()
        })
        self.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        superview?.addSubview(self)
        if animated! {
            UIView.animate(withDuration: self.animDuration, animations: {
                self.alpha = 1.0
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: { _ in
                UIView.animate(withDuration: self.animDuration, delay: delay!, options: [], animations: {
                    self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    self.alpha = 0.0
                }, completion: { (_) in
                    self.removeFromSuperview()
                    completion?()
                })
            })
        }
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex: Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

