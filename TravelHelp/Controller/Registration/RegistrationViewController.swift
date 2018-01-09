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

class RegistrationViewController: UIViewController,UITextFieldDelegate, AKFViewControllerDelegate {

    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var logInEmail: AnimationButton!
    @IBOutlet weak var logInPhone: AnimationButton!
    
    @IBOutlet weak var RegistrationButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    var accoutnKit: AKFAccountKit!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference(withPath: "users")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dissmisText))
        emailTextField.delegate = self
        passwordTextField.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
       
        if accoutnKit == nil {
            self.accoutnKit = AKFAccountKit(responseType: .accessToken)
            
        }
        Auth.auth().addStateDidChangeListener { [weak self](auth, user) in
            if user != nil{
                self?.performSegue(withIdentifier: "ShowMenu", sender: nil)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        logInEmail.layer.cornerRadius = logInEmail.frame.height / 2
        logInPhone.layer.cornerRadius = logInPhone.frame.height / 2
        // Shadow
//        logInEmail.layer.shadowOffset = CGSize(width: 5, height: 5)
//        logInEmail.layer.shadowOpacity = 0.3
//        logInEmail.layer.shadowRadius = 5
//        logInEmail.layer.shadowColor = UIColor(red:44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
//
//        logInPhone.layer.shadowOffset = CGSize(width: 5, height: 5)
//        logInPhone.layer.shadowOpacity = 0.8
//        logInPhone.layer.shadowRadius = 0
//        logInPhone.layer.shadowColor = UIColor.black.cgColor
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if accoutnKit.currentAccessToken != nil {
                        DispatchQueue.main.async(execute: {
                            self.performSegue(withIdentifier: "ShowMenu", sender: self)
                        })
//            self.performSegue(withIdentifier: "ShowMenu", sender: self)
        }
    }
    
    
    func prepareLoginViewController(_ loginViewController: AKFViewController){
        loginViewController.delegate = self
        loginViewController.setAdvancedUIManager(nil)
    
        
    }
    
    @objc func keyBoardDidShow(notification: Notification){
        guard let userInfo = notification.userInfo else {return}
        let keyBoardFrameSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue ).cgRectValue
        
        (self.view as! UIScrollView).setContentOffset(CGPoint(x:0,y:keyBoardFrameSize.height - 100), animated: true)
        
    }
    
    
    @objc func keyBoardDidHide(){
        //(self.view as! UIScrollView).setContentOffset(CGPoint(x:0,y:0), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        
        return true
    }
    
    @objc func dissmisText(){
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }
    
    // MARK: Login Button
    
    @IBAction func logInEmail(_ sender: AnimationButton) { // Login with email
        
        let inputState = UUID().uuidString
        let viewController = accoutnKit.viewControllerForEmailLogin(withEmail: nil, state: inputState) as AKFViewController
        viewController.enableSendToFacebook = true
        self.prepareLoginViewController(viewController)
        //sender.goLeft()
        //sender.shake()
        self.present(viewController as! UIViewController, animated: true, completion: nil)
        
       
        
    }
    
    @IBAction func logInPhone(_ sender: AnimationButton) {  // Login  with phone number
        
        let inputState = UUID().uuidString
        let viewController = accoutnKit.viewControllerForPhoneLogin(with: nil, state: inputState) as AKFViewController
        viewController.enableSendToFacebook = true
        self.prepareLoginViewController(viewController)
        sender.goRight()
        //sender.puls()

        self.present(viewController as! UIViewController, animated: true, completion: nil)
        
        
        
    }
    @IBAction func loginButton(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "",password != "" else {
            //displayWarnigLabel(withText: "Info is incorrecy")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] ( user, error) in
            if error != nil{
                //self?.displayWarnigLabel(withText: "Error occured")
                
                return
            }
            if user != nil{
                self?.performSegue(withIdentifier: "ShowMenu", sender: nil)
                return
            }
           // self?.displayWarnigLabel(withText: "No such user")
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

