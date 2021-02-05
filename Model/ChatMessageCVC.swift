//
//  ChatMessageCVC.swift
//  SimpleChatApp
//
//  Created by Student on 01.02.21.
//

import UIKit

class ChatMessageCVC: UICollectionViewCell {
    
    static let greenColor = UIColor(red: 107/255, green: 142/255, blue: 35/255, alpha: 0.8)
    
    var bubbleViewWidthAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?


    // MARK: - create Elements
    let textView: UITextView = {
       let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.backgroundColor = UIColor.clear
        textView.textColor = UIColor.white
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let profilImageView: UIImageView = {
      let imageView = UIImageView()
        imageView.image = UIImage(named: "default profilImage")
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let bubbleView: UIView = {
       let containerView = UIView()
        containerView.backgroundColor = greenColor
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    // MARK: - setup elements
    func setupBubbleView() {
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profilImageView.rightAnchor, constant: 8)
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleViewWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleViewWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    func setupTextView() {
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    func setupProfileImageView() {
        profilImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profilImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profilImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profilImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
    }
    
    
    func setupElements() {
        setupBubbleView()
        setupTextView()
        setupProfileImageView()
    }
    
    
    func addViews() {
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profilImageView)
    }
    
    func setDefaults() {
        addViews()
        setupElements()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDefaults()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
