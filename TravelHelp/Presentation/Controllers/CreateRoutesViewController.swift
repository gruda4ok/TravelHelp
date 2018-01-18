//
//  CreateRoutesViewController.swift
//  TravelHelp
//
//  Created by air on 15.01.2018.
//  Copyright © 2018 dogDeveloper. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class CreateRoutesViewController: UIViewController, GMSPlacePickerViewControllerDelegate {

    @IBOutlet weak var mapView: UIView!
    var currentLocation = CLLocation()
    var locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
    }
    
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let map = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        map.settings.myLocationButton = true
        map.settings.compassButton = true
        map.isMyLocationEnabled = true
        map.frame = view.bounds
        map.autoresizingMask = [.flexibleHeight, .flexibleWidth]
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
    
    @IBAction func pickerPlace(_ sender: UIButton) {
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
        dismiss(animated: true, completion: nil)
        print("No place selected")
    }
}
