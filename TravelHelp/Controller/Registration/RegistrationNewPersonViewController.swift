//
//  RegistrationNewPersonViewController.swift
//  TravelHelp
//
//  Created by air on 06.01.2018.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import UIKit
import Firebase

class RegistrationNewPersonViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference(withPath: "users")
        
    }
    
    
    @IBAction func registrationButton(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "",password != "" else {
            //displayWarnigLabel(withText: "Info is incorrecy")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            guard error == nil, user != nil else {
                print(error!.localizedDescription )
                return
            }
            
            let userRef = self.ref.child((user?.uid)!)
            userRef.setValue(["email": user?.email])
            //userRef.setValue(["name": user?.displayName])
        }
       dismiss(animated: true, completion: nil)
    }
    
}
