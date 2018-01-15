//
//  CreateNewTravelViewController.swift
//  TravelHelp
//
//  Created by air on 12.01.2018.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import UIKit

class CreateNewTravelViewController: UIViewController{

    private var user: UserModel? = AutorizationService.shared.localUser
    
    @IBOutlet private weak var travelPhotoImage: UIImageView!
    @IBOutlet private weak var addPhoto: AnimationButton!
    @IBOutlet private weak var createButton: AnimationButton!
    @IBOutlet private weak var nameTravelTextField: UITextField!
    @IBOutlet private weak var dateStartTextField: UITextField!
    @IBOutlet private weak var endDateTravelTextField: UITextField!
    @IBOutlet private weak var discriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPhoto.layer.cornerRadius = addPhoto.frame.height / 6
        createButton.layer.cornerRadius = createButton.frame.height / 2
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dissmisText))
        nameTravelTextField.delegate = self
        dateStartTextField.delegate = self
        endDateTravelTextField.delegate = self
        discriptionTextField.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @objc func keyBoardDidShow(notification: Notification){
        guard let userInfo = notification.userInfo else {return}
        let keyBoardFrameSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue ).cgRectValue
        (self.view as! UIScrollView).setContentOffset(CGPoint(x:0,y:keyBoardFrameSize.height - 100), animated: true)
    }
    
    @objc func keyBoardDidHide(){
        (self.view as! UIScrollView).setContentOffset(CGPoint(x:0,y:0), animated: true)
    }
    
   
    @IBAction func create(_ sender: AnimationButton) {
        
        guard
            let name = nameTravelTextField.text,
            let dateStart = dateStartTextField.text,
            let endDate = endDateTravelTextField.text,
            let discription = discriptionTextField.text,
            name != "",
            dateStart != "",
            endDate != "",
            discription != ""
        else{
            return
        }
       
        DatabaseService.shared.addTravel(name: name,
                                         user: user,
                                         dateStart: dateStart,
                                         endDate: endDate,
                                         discription: discription)
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension CreateNewTravelViewController: UIImagePickerControllerDelegate{
    
    @IBAction func addPhoto(_ sender: AnimationButton) {
        let image = UIImagePickerController()
        image.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true) {
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            travelPhotoImage.image = image
            addPhoto.isHidden = true
        }else{
            print("Error")
        }
    }
}

extension  CreateNewTravelViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTravelTextField.endEditing(true)
        dateStartTextField.endEditing(true)
        endDateTravelTextField.endEditing(true)
        discriptionTextField.endEditing(true)
        
        return true
    }
    
    @objc func dissmisText(){
        nameTravelTextField.endEditing(true)
        dateStartTextField.endEditing(true)
        endDateTravelTextField.endEditing(true)
        discriptionTextField.endEditing(true)
    }
}
