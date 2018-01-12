//
//  CreateNewTravelViewController.swift
//  TravelHelp
//
//  Created by air on 12.01.2018.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import UIKit

class CreateNewTravelViewController: UIViewController, UITextFieldDelegate {

    var user: UserModel? = AutorizationService.shared.localUser
    
    @IBOutlet weak var createButton: AnimationButton!
    @IBOutlet weak var nameTravelTextField: UITextField!
    @IBOutlet weak var dateStartTextField: UITextField!
    @IBOutlet weak var endDateTravelTextField: UITextField!
    @IBOutlet weak var discriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        (self.view as! UIScrollView).setContentOffset(CGPoint(x:0,y:keyBoardFrameSize.height), animated: true)
    }
    
    @objc func keyBoardDidHide(){
        (self.view as! UIScrollView).setContentOffset(CGPoint(x:0,y:0), animated: true)
    }
    
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
    
    @IBAction func create(_ sender: AnimationButton) {
        
        guard
            let name = nameTravelTextField.text,
            let dateStart = dateStartTextField.text,
            let endDate = endDateTravelTextField.text,
            let discription = discriptionTextField.text
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
