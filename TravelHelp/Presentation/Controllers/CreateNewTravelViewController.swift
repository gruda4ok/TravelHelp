//
//  CreateNewTravelViewController.swift
//  TravelHelp
//
//  Created by air on 12.01.2018.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import PKHUD

class CreateNewTravelViewController: UIViewController {

   
    @IBOutlet private weak var mapView: UIView!
    @IBOutlet private weak var travelPhotoImage: UIImageView!
    @IBOutlet private weak var addPhoto: AnimationButton!
    @IBOutlet private weak var createButton: AnimationButton!
    @IBOutlet private weak var nameTravelTextField: UITextField!
    @IBOutlet private weak var dateStartTextField: UITextField!
    @IBOutlet private weak var endDateTravelTextField: UITextField!
    @IBOutlet private weak var discriptionTextField: UITextField!
    
    private var map: GMSMapView!
    private var marker: GMSMarker!
    private var placeArrayCoordinate: Array<CLLocationCoordinate2D> = []
    private var placeNameArray: Array<String> = []
    private var user: UserModel? = AutorizationService.shared.localUser
    private var placesClient: GMSPlacesClient!
    private var imageModel: Image?
    private var travel: TravelBase?
    private var pathRoutes: GMSMutablePath?
    
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
        HUD.show(.progress)
        self.travel = DatabaseService.shared.addTravel(name: name,
                                                       user: user,
                                                       dateStart: dateStart,
                                                       endDate: endDate,
                                                       discription: discription)
        if let image = self.imageModel,
            let user = AutorizationService.shared.localUser,
            let travel = self.travel {
            StorageService.shared.saveImageTravel(image: image, user: user, travel: travel){
                HUD.hide()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        map = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        map.settings.myLocationButton = true
        map.settings.compassButton = true
        map.isMyLocationEnabled = true
        map.frame = mapView.bounds
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.addSubview(map)
        
        if let myLocation = map?.myLocation {
            print("User location\(myLocation)")
        }else{
            print("Not found user location")
        }
    }
    
    @IBAction func pickPlace(_ sender: UIButton) {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        present(placePicker, animated: true, completion: nil)
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        viewController.dismiss(animated: true, completion: nil)
        print("Place name \(place.name)")
        print("Place address \(String(describing: place.formattedAddress))")
        print("Place attributions \(String(describing: place.attributions))")
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
        print("No place selected")
    }
    
    @IBAction func addPlace(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
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

extension  CreateNewTravelViewController: UITextFieldDelegate {
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

extension CreateNewTravelViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        placeNameArray.append(place.placeID)
        placeArrayCoordinate.append(place.coordinate)
        
        marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        marker.map = map
        if  let lastPlace = placeNameArray.last,
            let preLastPlace = placeNameArray.dropLast().last{
            let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=place_id:\(lastPlace)&destination=place_id:\(preLastPlace)&key=AIzaSyBLTV2SSUBOdqE64iTztDYVAxlpYyj5rJY"
            guard let url = URL(string: urlString) else { return }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                guard error == nil else { return }
                do{
                    let direction = try JSONDecoder().decode(Derection.self, from: data)
                }catch let error{
                    print(error)
                }
            }.resume()
        dismiss(animated: true, completion: nil)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func placeAutocomplete() {
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        placesClient.autocompleteQuery("Sydney Oper", bounds: nil, filter: filter, callback: {(results, error) -> Void in
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                for result in results {
                    print("Result \(result.attributedFullText) with placeID \(String(describing: result.placeID))")
                }
            }
        })
    }
}
