//
//  MessageTVC.swift
//  SimpleChatApp
//
//  Created by Student on 01.02.21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class MessageTVC: UITableViewController {

    let dbUrlAsString = "https://thesimplechat-3e284-default-rtdb.europe-west1.firebasedatabase.app/"
    let cellID = "userCellID"

    var messages = [Message]()
    var messageDictionary = [String: Message]()
    var timer: Timer?
    
    
   @objc func handleReloadTableData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let ref = Database.database(url: dbUrlAsString).reference().child("user-messages").child(uid)
        
        ref.observe(.childAdded) { (data) in
            print(data)
            let messageId = data.key
            
            let messageRef = Database.database(url: self.dbUrlAsString).reference().child("messages").child(messageId)
            
            messageRef.observeSingleEvent(of: .value) { (data) in
                print(data)
                if let dic = data.value as?  [String: Any] {
                    let message = Message(dictionary: dic)
                    
                    //if let toUserWithUID = message.toUserWithUID {
                    if let chatPartnerId = message.chatPartnerId() {
                        self.messageDictionary[chatPartnerId] = message
                        self.messages = Array(self.messageDictionary.values)
                    }
                    
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTableData), userInfo: nil, repeats: false)
                }
            }
        }
    }
    
//    // lädt alle nachrichten runter
//    func observeMessages() {
//
//        let ref = Database.database(url: dbUrlAsString).reference().child("messages")
//        //print(ref)
//        ref.observe(.childAdded) { (data) in
//
//            if let dic = data.value as?  [String: Any] {
//                let message = Message(dictionary: dic)
//
//                if let toUserWithUID = message.toUserWithUID {
//                    self.messageDictionary[toUserWithUID] = message
//                    self.messages = Array(self.messageDictionary.values)
//                }
//
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
//        }
//    }
    
    func showChatControllerFor(_ user: UserModel) {
        let chatController = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.user = user
        //chatController.navigationItem.title = user.username
        navigationController?.pushViewController(chatController, animated: true)
    }
    
    
//    @objc func handleButtonTouchUpInside() {
//        print("test")
//        let chatController = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
//        navigationController?.pushViewController(chatController, animated: true)
//    }
    
    func setupNavigationBarWithUser(user: UserModel) {
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        //titleView.backgroundColor = UIColor.red

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let profilImageView = UIImageView()
        profilImageView.contentMode = .scaleAspectFill
        profilImageView.layer.cornerRadius = 20
        profilImageView.clipsToBounds = true
        profilImageView.translatesAutoresizingMaskIntoConstraints = false

        if let url = user.profilImageUrl {
            let profilImageURL = URL(string: url)

            profilImageView.sd_setImage(with: profilImageURL, completed: nil)
        }

        let nameLabel = UILabel()
        nameLabel.text = user.username
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        // add view elements
        titleView.addSubview(containerView)
        containerView.addSubview(profilImageView)
        containerView.addSubview(nameLabel)

        // layout der elemente
        profilImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profilImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profilImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profilImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        nameLabel.leftAnchor.constraint(equalTo: profilImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profilImageView.centerYAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profilImageView.heightAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true

        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
                navigationItem.titleView = titleView

        
//        let button = UIButton(type: .system)
//        button.setTitle(user.username, for: .normal)
//        button.addTarget(self, action: #selector(handleButtonTouchUpInside), for: .touchUpInside)
//        navigationItem.titleView = button
        
    }
    
    func fetchLoggedUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database(url: "https://thesimplechat-3e284-default-rtdb.europe-west1.firebasedatabase.app/").reference().child("users").child(uid).observeSingleEvent(of: .value) { (data) in
            if let dic = data.value as? [String: Any] {
                let user = UserModel(dictionary: dic)
                self.setupNavigationBarWithUser(user: user)
            }
        }
    }
    
    @objc func handleNewMessage() {
        print("search button pressed")
        let newMessageTVC = NewMessageTVC()
        newMessageTVC.messageController = self
        let navController = UINavigationController(rootViewController: newMessageTVC)
        
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
    
    @objc func handleLogout() {
        //print("logout button pressed")
        // nutzer ausloggen
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        // zurück zum login controller
        dismiss(animated: true, completion: nil)
    }
    
    func setButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleNewMessage))
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("zeile \(indexPath.row)")
        
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else {return}
        
        // daten vom/an chatpartner herunterladen
        let chatPartnerRef = Database.database(url: dbUrlAsString).reference().child("users").child(chatPartnerId)
        
        chatPartnerRef.observeSingleEvent(of: .value) { (data) in
            guard let dic = data.value as? [String: Any] else {return}
            let user = UserModel(dictionary: dic)
            user.uid = chatPartnerId
            
            self.showChatControllerFor(user)
        }
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell

        // Configure the cell...
        let message = messages[indexPath.row]
        cell.message = message

        return cell
    }

    
    
    // MARK: - setDefaults
    func setDefaults() {
        tableView.rowHeight = 80
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        setButtons()
        fetchLoggedUser()
        //observeMessages()
        observeUserMessages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchLoggedUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaults()
    }
}
