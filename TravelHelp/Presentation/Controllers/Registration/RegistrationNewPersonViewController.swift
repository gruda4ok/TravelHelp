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

    @IBOutlet weak var addPhotoButton: AnimationButton!
    @IBOutlet weak var photoPersonImage: UIImageView!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var registrationButton: AnimationButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registrationButton.layer.cornerRadius = registrationButton.frame.height / 4
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.height / 4
        photoPersonImage.layer.cornerRadius = photoPersonImage.frame.height / 2
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dissmisText))
        emailTextField.delegate = self
        passwordTextField.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @IBAction func registrationButton(_ sender: UIButton) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text,
            let phone = phoneNumberTextField.text,
            email != "",
            password != "",
            name != "",
            phone != ""
            else {
            //displayWarnigLabel(withText: "Info is incorrecy")
            return
        }
        AutorizationService.shared.registerUser(email: email, password: password, name: name, phoneNumber: phone)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func keyBoardDidShow(notification: Notification){
       // guard let userInfo = notification.userInfo else {return}
       // let keyBoardFrameSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue ).cgRectValue
        (self.view as! UIScrollView).setContentOffset(CGPoint(x:0,y:0), animated: true)
    }
    
    @objc func keyBoardDidHide(){
        (self.view as! UIScrollView).setContentOffset(CGPoint(x:0,y:0), animated: true)
    }
}

extension RegistrationNewPersonViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        nameTextField.endEditing(true)
        phoneNumberTextField.endEditing(true)
        return true
    }
    
    @objc func dissmisText(){
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        nameTextField.endEditing(true)
        phoneNumberTextField.endEditing(true)
    }
}
extension RegistrationNewPersonViewController: UIImagePickerControllerDelegate{
    
    @IBAction func addPhotoButton(_ sender: AnimationButton) {
        let image = UIImagePickerController()
        image.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true) {
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            photoPersonImage.image = image
            addPhotoButton.isHidden = true
        }else{
            print("Error")
        }
    }
}
