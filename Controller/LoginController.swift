//
//  LoginController.swift
//  SimpleChatApp
//
//  Created by Student on 01.02.21.
//


/*
 Aktuell angelegte User:
 
    ben@test.de
    du@test.de
    er@test.de
    sie@test.de
    alex@test.de
 
 Standard-PW:
 
    123456
 
 */

import UIKit
import Firebase

class LoginController: UIViewController {
    
    // MARK: - global variables
    
    var containerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    // MARK: - choose profile image
    @objc func handleSelectProfilePicture() {
        print("profile picture tapped")
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    
    func addTapGestureToProfileView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectProfilePicture))
        profilImageView.addGestureRecognizer(tapGesture)
        profilImageView.isUserInteractionEnabled = true
    }
    
    
    @objc func handleUserInput(_ sender: UITextField) {
        if !(emailTextField.text!.isEmpty) && !(passwordTextField.text!.isEmpty) {
            loginRegisterButton.backgroundColor = UIColor.init(white: 1.0, alpha: 0.8)
            loginRegisterButton.setTitleColor(UIColor.black, for: .normal)
            loginRegisterButton.isEnabled = true
        } else {
            loginRegisterButton.backgroundColor = UIColor.init(white: 1.0, alpha: 0.2)
            loginRegisterButton.setTitleColor(UIColor.white, for: .normal)
            loginRegisterButton.isEnabled = false
        }
    }

    
    func changeContainerViewToTwoTextFields() {
        containerViewHeightAnchor?.isActive = false
        containerViewHeightAnchor = containerView.heightAnchor.constraint(equalToConstant: 100)
        containerViewHeightAnchor?.isActive = true
        
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalToConstant: 0)
        nameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/2)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/2)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func changeContainerViewToThreeTextFields() {
        containerViewHeightAnchor?.isActive = false
        containerViewHeightAnchor = containerView.heightAnchor.constraint(equalToConstant: 150)
        containerViewHeightAnchor?.isActive = true
        
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    // MARK: - add Targets
    @objc func handleNoAccount(_ sender: UIButton) {
        if sender.titleLabel?.text == "Du hast noch keinen Account?" {
            profilImageView.alpha = 1.0
            loginRegisterButton.setTitle("Registrieren", for: .normal)
            dontHaveAnAccountButton.setTitle("zum Login", for: .normal)
            
            changeContainerViewToThreeTextFields()
            
        } else  if sender.titleLabel?.text == "zum Login" {
            profilImageView.alpha = 0.0
            loginRegisterButton.setTitle("Login", for: .normal)
            dontHaveAnAccountButton.setTitle("Du hast noch keinen Account?", for: .normal)
            
            changeContainerViewToTwoTextFields()
        }
    }
    
    // MARK: - create Elements
    let dontHaveAnAccountButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.setTitle("Du hast noch keinen Account?", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let loginRegisterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        button.layer.cornerRadius = 5
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let emailSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "   Password"
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "   Email"
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "   UserName"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let profilImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.white
        imageView.image = UIImage(named: "default profilImage")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.frame.size.width = 140
        imageView.frame.size.height = 140
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.alpha = 0.0
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "SimpleChatApp"
        label.font = UIFont(name: "Chalkduster", size: 24)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    // MARK: - setup elements
    func setupDontHaveAnAccountButton() {
        dontHaveAnAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dontHaveAnAccountButton.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 5).isActive = true
        dontHaveAnAccountButton.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        dontHaveAnAccountButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupLoginRegisterButton() {
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupEmailSeperatorView() {
        emailSeperatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        emailSeperatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeperatorView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        emailSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupNameSeperatorView() {
        nameSeperatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        nameSeperatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeperatorView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        nameSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupPasswordTextField() {
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/2)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func setupEmailTextField() {
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/2)
        emailTextFieldHeightAnchor?.isActive = true
    }
    
    func setupNameTextField() {
        nameTextField.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalToConstant: 0)
        nameTextFieldHeightAnchor?.isActive = true

    }
    
    func setupContainerView() {
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        containerViewHeightAnchor = containerView.heightAnchor.constraint(equalToConstant: 100)
        containerViewHeightAnchor?.isActive = true
        
        setupNameTextField()
        setupNameSeperatorView()
        setupEmailTextField()
        setupEmailSeperatorView()
        setupPasswordTextField()
    }
    
    func setupProfilImageView() {
        profilImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilImageView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -20).isActive = true
        profilImageView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        profilImageView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
    }
    
    func setupTitleLabel() {
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
    }
    
    func setupBasicView() {
        self.view.backgroundColor = UIColor.init(red: 107/255, green: 142/255, blue: 35/255, alpha: 0.6)
    }
    
    
    func setupEvents() {
        dontHaveAnAccountButton.addTarget(self, action: #selector(handleNoAccount(_:)), for: .touchDown)
        loginRegisterButton.addTarget(self, action: #selector(handleLoginRegister(_:)), for: .touchDown)
        emailTextField.addTarget(self, action: #selector(handleUserInput(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleUserInput(_:)), for: .editingChanged)
        addTapGestureToProfileView()
    }

    func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(profilImageView)
        view.addSubview(containerView)
        
        containerView.addSubview(nameTextField)
        containerView.addSubview(nameSeperatorView)
        containerView.addSubview(emailTextField)
        containerView.addSubview(emailSeperatorView)
        containerView.addSubview(passwordTextField)
        
        view.addSubview(loginRegisterButton)
        view.addSubview(dontHaveAnAccountButton)
    }
    
    func setupElements() {
        setupBasicView()
        setupTitleLabel()
        setupProfilImageView()
        setupContainerView()
        setupLoginRegisterButton()
        setupDontHaveAnAccountButton()
    }
    
    func setDefaults() {
        setupViews()
        setupElements()
        setupEvents()
    }
    

    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        setDefaults()
    }
}


// MARK: - extensions

extension LoginController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            profilImageView.image = editImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            profilImageView.image = originalImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}


extension LoginController: UINavigationControllerDelegate {
    
}
