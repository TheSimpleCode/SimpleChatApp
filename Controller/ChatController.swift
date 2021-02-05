//
//  ChatController.swift
//  SimpleChatApp
//
//  Created by Student on 01.02.21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ChatController: UICollectionViewController {
    
    let dbUrlAsString = "https://thesimplechat-3e284-default-rtdb.europe-west1.firebasedatabase.app/"
    let cellId = "MessageCellId"
    
    var messages = [Message]()
    
    var user: UserModel? {
        didSet {
            navigationItem.title = user?.username
            
            observeMessages()
        }
    }
    
    lazy var inputTextField: UITextField = {
       let textField = UITextField()
        textField.placeholder = "Enter message"
        textField.backgroundColor = UIColor.white
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        print("keyboard hides")
        print(notification)
        let keyboardDurationTime = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = 0
        
        UIView.animate(withDuration: keyboardDurationTime!) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        print("keyboard shows up")
        print(notification)
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDurationTime = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue

        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDurationTime!) {
            self.view.layoutIfNeeded()
        }

    }
    
    func setupKeyboardObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
    }
    
    func setupCell(_ cell: ChatMessageCVC, message: Message) {
        if let profilImageUrl = user?.profilImageUrl {
            let url = URL(string: profilImageUrl)
            
            cell.profilImageView.sd_setImage(with: url, completed: nil)
        }
        
        // farben der bubbles festlegen
        if message.fromUserWithUID == Auth.auth().currentUser?.uid {
            // grün wenn nachricht von eingeloggtem user
            cell.bubbleView.backgroundColor = ChatMessageCVC.greenColor
            cell.textView.textColor = UIColor.white
            cell.profilImageView.isHidden = true
            
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        } else {
            // blau wenn nachrichtan eingeloggten user
            cell.bubbleView.backgroundColor = UIColor(red: 70/255, green: 130/255, blue: 180/255, alpha: 0.8)
            cell.textView.textColor = UIColor.black
            cell.profilImageView.isHidden = false
            
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
    }
    
    // load messages
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let userMessageRef = Database.database(url: dbUrlAsString).reference().child("user-messages").child(uid)
        
        userMessageRef.observe(.childAdded) { (data) in
            print(data)
            
            let messageId = data.key
            let messageRef = Database.database(url: self.dbUrlAsString).reference().child("messages").child(messageId)
            
            messageRef.observeSingleEvent(of: .value) { (data) in
                guard let dic = data.value as? [String: Any] else {return}
                let message = Message(dictionary: dic)
                
                if message.chatPartnerId() == self.user?.uid {
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    
    @objc func handleSendButtonTapped() {
        let reference = Database.database(url: dbUrlAsString).reference().child("messages")
        let childRef = reference.childByAutoId() // erstellt eine unique number je nachricht
        
        // von welchem nutzer kommt das
        guard let fromUserWithUID = Auth.auth().currentUser?.uid else {return}
        
        // an welchen nutzer geht das
        guard let toUserWithUID = user?.uid else {return}
        
        // zeitstempel der nachricht
        let timestamp = Int(Date().timeIntervalSince1970)
        
        guard let message = inputTextField.text else {return}
        
        let dicData: [String: Any] = ["message": message, "fromUserWithUID": fromUserWithUID, "toUserWithUID": toUserWithUID, "timestamp": timestamp ]
        //childRef.updateChildValues(dicData)
    
        childRef.updateChildValues(dicData) { (error, data) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            guard let messageId = childRef.key else {return}

            let userMessageRef = Database.database(url: self.dbUrlAsString).reference().child("user-messages").child(fromUserWithUID)
            
          //  let messageId = childRef.key
            let dic = [messageId: 1]
            userMessageRef.updateChildValues(dic)
        
            let recipientUserMessageRef = Database.database(url: self.dbUrlAsString).reference().child("user-messages").child(toUserWithUID)
            
            recipientUserMessageRef.updateChildValues(dic)
        }
        
        clearInputTextField()
    }
    
    func clearInputTextField() {
        
        inputTextField.text = ""
    }
    
    
    func setupInputComponents() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.backgroundColor = UIColor.white
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSendButtonTapped), for: .touchUpInside)
        
        containerView.addSubview(sendButton)
        containerView.addSubview(inputTextField)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/5).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        inputTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor = UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(seperatorLineView)
        
        seperatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCVC
        
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        
        setupCell(cell, message: message)
        
        cell.bubbleViewWidthAnchor?.constant = estimateFrameForText(text: message.text!).width + 32
        
        return cell
    }
    
    
    func setCollectionView() {
        collectionView.backgroundColor = UIColor.white
        collectionView.register(ChatMessageCVC.self, forCellWithReuseIdentifier: cellId)
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 60, right: 0)
    }
    
    func setDefaults() {
        //navigationItem.title = "Chat Controller"
        setCollectionView()
        inputTextField.delegate = self
        setupInputComponents()
        setupKeyboardObserve()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaults()
    }
}

extension ChatController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // nachricht zur db los schicken
        handleSendButtonTapped()
        return true
    }
}


extension ChatController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80

        if let text = messages[indexPath.item].text {
            let size = estimateFrameForText(text: text)
            height = size.height + 20
        }

        let size = CGSize(width: view.frame.width, height: height)
        
        return size
    }
    
}
