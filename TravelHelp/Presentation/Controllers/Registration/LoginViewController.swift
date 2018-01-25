//
//  ViewController.swift
//  TravelHelp
//
//  Created by air on 18.12.2017.
//  Copyright © 2017 dogDeveloper. All rights reserved.
//

import UIKit
import AccountKit
import Firebase
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController {

    @IBOutlet weak var loginFBButton: UIStackView!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet private weak var logInEmail: AnimationButton!
    @IBOutlet private weak var logInPhone: AnimationButton!
    @IBOutlet private weak var RegistrationButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    
    var accoutnKit: AKFAccountKit!
    
    //MARK: - Live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGesture()
        setupNotification()
        setupInterface()
      
        if accoutnKit == nil {
            self.accoutnKit = AKFAccountKit(responseType: .accessToken)
        }
    }

    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dissmisText))
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, let accessToken):
                print("Logged in!")
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                Auth.auth().signIn(with: credential) { (user, error) in
                    guard
                        let email = user?.email,
                        let uid = user?.uid,
                        let name = user?.displayName,
                        let phoneNumber = user?.phoneNumber
                    else {
                        return
                    }
                    DatabaseService.shared.saveUser(uid: uid, email: email, name: name, phoneNumber: phoneNumber)
                    self.performSegue(withIdentifier: "ShowMenu", sender: nil)
                }
            }
        }
    }

    func setupInterface() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        logInEmail.layer.cornerRadius = logInEmail.frame.height / 2
        logInPhone.layer.cornerRadius = logInPhone.frame.height / 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil{
                self?.performSegue(withIdentifier: "ShowMenu", sender: nil)
            }
        }
            if accoutnKit.currentAccessToken != nil {
                        DispatchQueue.main.async(execute: {
                            self.performSegue(withIdentifier: "ShowMenu", sender: self)
                        })
            self.performSegue(withIdentifier: "ShowMenu", sender: self)
        }
        if AccessToken.current != nil {
            performSegue(withIdentifier: "ShowMenu", sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        passwordTextField.text = ""
        emailTextField.text = ""
    }
    
    func prepareLoginViewController(_ loginViewController: AKFViewController) {
        loginViewController.delegate = self
        loginViewController.setAdvancedUIManager(nil)
    }
    
    @objc func keyBoardDidShow(notification: Notification) {
        if let view = view as? UIScrollView {
            view.setContentOffset(CGPoint(x:0,y:0), animated: true)
        }
    }
    
    @objc func keyBoardDidHide() {
        if let view = view as? UIScrollView {
            view.setContentOffset(CGPoint(x:0,y:0), animated: true)
        }
    }
    
    // MARK: - Action
    
    @IBAction func loginButton(_ sender: UIButton) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            email != "",password != "" else {
            return
        }
        
        AutorizationService.shared.loginUser(email: email, password: password){  [weak self] in
            self?.performSegue(withIdentifier: "ShowMenu", sender: nil)
        }
    }
    
    @IBAction func registrationButton(_ sender: UIButton) {
        performSegue(withIdentifier: "RegNewPerson", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMwnu"{
            let dvc = segue.destination as! RegistrationNewPersonViewController
            dvc.emailTextField.text = emailTextField.text
        }
    }
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        return true
    }
    
    @objc func dissmisText(){
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }
}

extension LoginViewController: AKFViewControllerDelegate {
    @IBAction func logInEmail(_ sender: AnimationButton) { // Login with email
        
        let inputState = UUID().uuidString
        let viewController = accoutnKit.viewControllerForEmailLogin(withEmail: nil, state: inputState) as AKFViewController
        viewController.enableSendToFacebook = true
        self.prepareLoginViewController(viewController)
        self.present(viewController as! UIViewController, animated: true, completion: nil)
    }
    
    @IBAction func logInPhone(_ sender: AnimationButton) {  // Login  with phone number
        let inputState = UUID().uuidString
        let viewController = accoutnKit.viewControllerForPhoneLogin(with: nil, state: inputState) as AKFViewController
        viewController.enableSendToFacebook = true
        self.prepareLoginViewController(viewController)
        self.present(viewController as! UIViewController, animated: true, completion: nil)
    }
}

