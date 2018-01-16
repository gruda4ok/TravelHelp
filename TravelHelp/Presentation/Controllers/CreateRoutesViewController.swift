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

class CreateRoutesViewController: UIViewController {

    var currentLocation = CLLocation()
    var locationManager = CLLocationManager()
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
    }
    
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        if let myLocation = mapView.myLocation {
            print("User location\(myLocation)")
        }else{
            print("Not found user location")
        }
    }
}
