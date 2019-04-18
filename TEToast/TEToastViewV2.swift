//
//  TEToastViewV2.swift
//  TEToastViewV2
//
//  Created by Tatevik Tovmasyan on 4/11/19.
//  Copyright © 2019 Tatevik Tovmasyan. All rights reserved.
//

import UIKit

enum ToastViewPosition {
    case centered
    case boundary(position: BoundaryPosition, inset: CGFloat)
    
    enum BoundaryPosition {
        case top
        case bottom
    }
}

class TEToastViewV2: UIView {
    fileprivate var imageView: UIImageView!
    fileprivate var titleLabel: UILabel!
    fileprivate var commentLabel: UILabel!
    
    fileprivate var position: ToastViewPosition!
    
    fileprivate var stackView: UIStackView!
    fileprivate var horizontalStackView: UIStackView!
    
    init(image: UIImage?, title: String?, comment: String?, position: ToastViewPosition) {
        super.init(frame: .zero)
        self.position = position
        self.configStackViews()
        self.setAppearance()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        
        if let image = image {
            self.addImageView(image: image)
        }
        
        if let title = title {
            self.addTitleLabel(title: title)
        }
        
        if let comment = comment {
            self.addCommentLabel(comment: comment)
        }
        
        if self.titleLabel == nil && self.commentLabel == nil && self.imageView != nil {
            switch self.position! {
            case .centered:
                let widthConstraint = imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8 * 0.3)
                widthConstraint.priority = .defaultHigh
                widthConstraint.isActive = true
            case .boundary:
                let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8 * 0.2)
                heightConstraint.priority = .defaultHigh
                heightConstraint.isActive = true
            }
        }
        
        self.configStackViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setAppearance() {
        self.layer.cornerRadius = 3
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 6
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.3
    }
    
    fileprivate func configStackViews() {
        self.stackView = UIStackView()
        self.stackView.axis = .vertical
        self.stackView.distribution = .fill
        self.stackView.spacing = 4.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        switch self.position! {
        case .centered:
            self.addSubview(stackView)
        case .boundary:
            self.horizontalStackView = UIStackView()
            self.horizontalStackView.axis = .horizontal
            self.horizontalStackView.distribution = .fill
            self.horizontalStackView.spacing = 4.0
            horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(horizontalStackView)
        }
    }
    
    fileprivate func configStackViewConstraints() {
        switch self.position! {
        case .centered:
            self.addSubview(stackView)
            NSLayoutConstraint.activate([stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10.0),
                                         stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
                                         stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0),
                                         stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10.0)])
        case .boundary:
            NSLayoutConstraint.activate([horizontalStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10.0),
                                         horizontalStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
                                         horizontalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0),
                                         horizontalStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10.0)])
        }
        self.layoutIfNeeded()
    }
    
    fileprivate func addImageView(image: UIImage) {
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 250), for: .horizontal)
        imageView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 250), for: .vertical)
        
        switch self.position! {
        case .boundary:
            let widthConstraint: NSLayoutConstraint = imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8 * 0.2)
            widthConstraint.priority = .defaultHigh
            widthConstraint.isActive = true
            self.horizontalStackView.addArrangedSubview(imageView)
        case .centered:
            let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8 * 0.3)
            heightConstraint.priority = .defaultHigh
            heightConstraint.isActive = true
            self.stackView.addArrangedSubview(imageView)
        }
        self.layoutIfNeeded()
    }
    
    fileprivate func addTitleLabel(title: String) {
        switch self.position! {
        case .boundary:
            if !self.subviews.contains(stackView) {
                self.horizontalStackView.addArrangedSubview(stackView)
            }
        case .centered:
            break
        }
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .darkGray
        titleLabel.font = UIFont.systemFont(ofSize: 15.0)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        self.stackView.addArrangedSubview(titleLabel)
    }
    
    fileprivate func addCommentLabel(comment: String) {
        switch self.position! {
        case .boundary:
            if !self.subviews.contains(stackView) {
                self.horizontalStackView.addArrangedSubview(stackView)
            }
        case .centered:
            break
        }
        commentLabel = UILabel()
        commentLabel.text = comment
        commentLabel.textColor = .lightGray
        commentLabel.font = UIFont.systemFont(ofSize: 11.0)
        commentLabel.numberOfLines = 0
        commentLabel.textAlignment = .center
        self.stackView.addArrangedSubview(commentLabel)
    }
    
    fileprivate func add(inSuperview superview: UIView) {
        superview.addSubview(self)
        
        switch self.position! {
        case .centered:
            NSLayoutConstraint.activate([self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                                        self.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
                                        self.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 0.8),
                                        self.widthAnchor.constraint(greaterThanOrEqualToConstant: UIScreen.main.bounds.width * 0.3)])
        case .boundary(let position, let inset):
            NSLayoutConstraint.activate([self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                                         self.heightAnchor.constraint(greaterThanOrEqualToConstant: UIScreen.main.bounds.width * 0.2),
                                         self.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 0.8),
                                         self.widthAnchor.constraint(greaterThanOrEqualToConstant: UIScreen.main.bounds.width * 0.3)])
            
            switch position {
            case .top:
                self.topAnchor.constraint(equalTo: superview.topAnchor, constant: inset).isActive = true
            case .bottom:
                self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -inset).isActive = true
            }
        }
        superview.layoutIfNeeded()
    }
    
    func present(inSuperview superview: UIView, hideAfter delay: TimeInterval? = 5,
                 animated: Bool? = true, completion: (()->Void)? = nil) {
        self.add(inSuperview: superview)
        
        if animated! {
            self.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            self.alpha = 0.0
            UIView.animate(withDuration: 0.25, animations: {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.alpha = 1.0
            }, completion: { _ in
                UIView.animate(withDuration: 0.25, delay: delay!, options: [], animations: {
                    self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    self.alpha = 0.0
                }, completion: { (_) in
                    self.removeFromSuperview()
                    completion?()
                })
            })
        } else {
            self.alpha = 1.0
            UIView.animate(withDuration: 0, delay: delay!, options: [], animations: {
                self.alpha = 0.0
            }, completion: { (_) in
                self.removeFromSuperview()
                completion?()
            })
        }
    }
}
