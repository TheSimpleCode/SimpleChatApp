//
//  LoginController_Extension.swift
//  SimpleChatApp
//
//  Created by Student on 01.02.21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


extension LoginController {
    
    
    
    func showMessageController() {
        let messageTVC = MessageTVC()
        let navController = UINavigationController(rootViewController: messageTVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
        
    }
    
    func createUser(){
        // account erstellen
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
            if let err = error {
                print(err)
                return
            }
            
            print("Nutzer erstellt")

            // nutzerdaten in variablen speichern
            guard let newUser = result else { return }
            let uid = newUser.user.uid
            
            guard let userName = self.nameTextField.text else { return }
            let email = self.emailTextField.text!
        
            // foto in firebase storage speichern
            let storageRef = Storage.storage().reference().child("profil_image").child(uid)
            guard let image = self.profilImageView.image else { return }
            guard let uploadImage = image.jpegData(compressionQuality: 0.1) else { return }
            
            storageRef.putData(uploadImage, metadata: nil) { (metadata, error) in
                if let err = error {
                    print(err.localizedDescription)
                    return
                }
                
                storageRef.downloadURL { (url, error) in
                    if let err = error {
                        print(err.localizedDescription)
                        return
                    }
                    
                    let profiImageUrlAsString = url?.absoluteString
                    
                    // verbindung zu db aufbauen
                    let ref = Database.database(url: "https://thesimplechat-3e284-default-rtdb.europe-west1.firebasedatabase.app/").reference().child("users").child(uid)
               
                    // dictionary nutzen [key : value] um user in db und image im storage einzutragen
                    ref.setValue(["uid": uid,"username": userName, "email": email, "profilImageURL": profiImageUrlAsString ?? "kein Bild vorhanden"])
                    
                    print(uid)
                    self.showMessageController()
                }
            }
            
            self.clearTextFields()
        }
    }
    
    func userLogin(){
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
            
            
            if let err = error {
                print(err)
                print("Login fehlgeschlagen")
                
                let alert = UIAlertController(title: "Login fehlgeschlagen", message: "Passwort falsch oder User existiert nicht", preferredStyle: .alert)
                    
                     let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                     })
                     alert.addAction(ok)
                     let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
                     })
                     alert.addAction(cancel)
                     DispatchQueue.main.async(execute: {
                        self.present(alert, animated: true)
                })
                
                self.clearTextFields()
                
                return
            }
            
            print("Nutzer eingeloggt")
            self.showMessageController()
            self.clearTextFields()
        }
    }
    
    func clearTextFields() {
        nameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @objc func handleLoginRegister(_ sender: UIButton) {
        if sender.titleLabel?.text == "Login" {
            // login routine
            userLogin()
        } else {
            //nutzer erstellen
            createUser()
        }
        
    }
    
    // MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        // autologin
        if Auth.auth().currentUser != nil {
            print("Autologin erfolgt")
            self.showMessageController()
        }
    }
    
}
