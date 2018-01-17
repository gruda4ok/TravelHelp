//
//  CreateNewTravelViewController.swift
//  TravelHelp
//
//  Created by air on 12.01.2018.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import UIKit
import GoogleMaps

class CreateNewTravelViewController: UIViewController {

    private var user: UserModel? = AutorizationService.shared.localUser
    
    @IBOutlet weak var mapView: UIView!
    @IBOutlet private weak var travelPhotoImage: UIImageView!
    @IBOutlet private weak var addPhoto: AnimationButton!
    @IBOutlet private weak var createButton: AnimationButton!
    @IBOutlet private weak var nameTravelTextField: UITextField!
    @IBOutlet private weak var dateStartTextField: UITextField!
    @IBOutlet private weak var endDateTravelTextField: UITextField!
    @IBOutlet private weak var discriptionTextField: UITextField!
    
    var imageModel: Image?
    var travel: TravelBase?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGesture()
        setupInterface()
        setupNotification()
        setupMap()
    }
    
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dissmisText))
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupInterface() {
        addPhoto.layer.cornerRadius = addPhoto.frame.height / 6
        createButton.layer.cornerRadius = createButton.frame.height / 2
        nameTravelTextField.delegate = self
        dateStartTextField.delegate = self
        endDateTravelTextField.delegate = self
        discriptionTextField.delegate = self
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @objc func keyBoardDidShow(notification: Notification){
        if let view = view as? UIScrollView {
            view.setContentOffset(CGPoint(x:0,y:0), animated: true)
        }
    }
    
    @objc func keyBoardDidHide() {
        if let view = view as? UIScrollView {
            view.setContentOffset(CGPoint(x:0,y:0), animated: true)
        }
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
        if let image = self.imageModel,
            let user = self.user,
            let travel = self.travel
        {
            StorageService.shared.saveImageTravel(image: image, user: user, travel: travel)
        }
    }
    
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let map = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        map.settings.myLocationButton = true
        map.settings.compassButton = true
        map.isMyLocationEnabled = true
        map.frame = mapView.bounds
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.addSubview(map)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = map
        
        if let myLocation = map.myLocation {
            print("User location\(myLocation)")
        }else{
            print("Not found user location")
        }
    }
}

extension CreateNewTravelViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBAction func addPhoto(_ sender: AnimationButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = false
        self.present(picker, animated: true) {
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if  let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let url = info[UIImagePickerControllerImageURL] as? NSURL,
            let pathExtension = url.pathExtension {
            travelPhotoImage.image = image
            addPhoto.isHidden = true
            imageModel = Image(image: image, extention: pathExtension)
        }else{
            print("Error")
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
