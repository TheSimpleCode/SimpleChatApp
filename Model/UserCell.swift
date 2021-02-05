//
//  UserCell.swift
//  SimpleChatApp
//
//  Created by Student on 01.02.21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SDWebImage

class UserCell: UITableViewCell {

    
    let dbUrlAsString = "https://thesimplechat-3e284-default-rtdb.europe-west1.firebasedatabase.app/"

    var message: Message? {
        didSet {
            
            let chatPartnerId: String?
            
            if message?.fromUserWithUID == Auth.auth().currentUser?.uid {
                chatPartnerId = message?.toUserWithUID
            } else {
                chatPartnerId = message?.fromUserWithUID
            }
            
            //if let toUserWithUID = message?.toUserWithUID {
            if let id = chatPartnerId {
                let ref = Database.database(url: dbUrlAsString).reference().child("users").child(id)
                
                ref.observeSingleEvent(of: .value) { (data) in
                    // name laden und anzeigen
                    if let dic = data.value as? [String: Any] {
                        self.textLabel?.text = dic["username"] as? String
                        
                        // profilbild laden und anzeigen
                        if let profilImageURL = dic["profilImageURL"] as? String {
                            let url = URL(string: profilImageURL)
                            self.profileImageView.sd_setImage(with: url, completed: nil)
                        }
                    }
                }
                
                // letzter text und zeitstempel der kommunikation mit dem entsprechenden user in der cell anzeigen
                if let messageText = message?.text {
                    detailTextLabel?.text = messageText
                }
                
                if let seconds = message?.timestamp {
                    let timeDate = Date(timeIntervalSince1970: Double(seconds))
                                        
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm:ss"
                    
                    timeLabel.text = dateFormatter.string(from: timeDate)
                }
            }
        }
    }
    
    
    
    // MARK: - setup elements
    func setupTimeLabel() {
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
    }
    
    func setupProfileImageView() {
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
    }
    
    func setupElements() {
        setupTimeLabel()
        setupProfileImageView()
    }
    
    // MARK: - create elements
    let timeLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        //label.text = "Zeitpunkt"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let profileImageView: UIImageView = {
       let imageView = UIImageView(image: UIImage(named: "default profilImage"))
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func addViews() {
        addSubview(timeLabel)
        addSubview(profileImageView)
    }
    
    // MARK: - setDefaults
    func setDefaults() {
        addViews()
        setupElements()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "userCell")
        super.awakeFromNib()
        
        setDefaults()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
