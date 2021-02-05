//
//  NewMessageTVCTableViewController.swift
//  SimpleChatApp
//
//  Created by Student on 01.02.21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage


class NewMessageTVC: UITableViewController {

    let cellId = "userCell"
    let dbUrlAsString = "https://thesimplechat-3e284-default-rtdb.europe-west1.firebasedatabase.app/"
    
    var users = [UserModel]()
    var messageController: MessageTVC?
    
    func fetchUser() {
        Database.database(url: dbUrlAsString).reference().child("users").observe(.childAdded) { (data) in
            if let dic = data.value as? [String: Any] {
                let user = UserModel(dictionary: dic)
                
                // nur user in das array hinzufügen, die nicht dem gerade eingeloggten entsprechen
                if user.uid != Auth.auth().currentUser?.uid {
                    self.users.append(user)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func handleCancel() {
     
        // zurück zum login controller
        dismiss(animated: true, completion: nil)
    }
    
    func createButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleCancel))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return the number of rows
        //return 10
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let userObject = users[indexPath.row]
        
        // configure the cell
        //cell.textLabel?.text = "Test"
        //cell.textLabel?.text = users[indexPath.row].username
        cell.textLabel?.text = userObject.username
        cell.detailTextLabel?.text = userObject.email
        
        
        // profilbild laden
        if let imageUrl = userObject.profilImageUrl {
            
            let profilImageUrl = URL(string: imageUrl)
            
            cell.profileImageView.sd_setImage(with: profilImageUrl, completed: nil)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("zeile\(indexPath.row )")
        dismiss(animated: true) {
            let user = self.users[indexPath.row]
            
            guard let messageTVC = self.messageController else { return }
            
            messageTVC.showChatControllerFor(user)
        }
    }
    
    func setDefaults() {
        // gib der table viwe bescheid, welche cell anstatt der standard
        // verwendet werden soll inkl. klasse und identifier der cell
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        createButtons()
        fetchUser()
        tableView.rowHeight = 100
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaults()
    }
}


