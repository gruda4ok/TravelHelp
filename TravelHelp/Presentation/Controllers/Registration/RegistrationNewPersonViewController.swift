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
    
    @IBAction func registrationButton(_ sender: UIButton) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text,
            email != "",
            password != "",
            name != ""
            else {
            //displayWarnigLabel(withText: "Info is incorrecy")
            return
        }
        
        AutorizationService.shared.registerUser(email: email, password: password, name: name)
        
       dismiss(animated: true, completion: nil)
    }
    
}
