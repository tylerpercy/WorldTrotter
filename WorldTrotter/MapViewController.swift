//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Tyler Percy on 2/11/19.
//  Copyright © 2019 Tyler Percy. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    //Initializing the buttons using their respective classes
    //Programmatically creating the buttons allows for more customization
    var mapView: MKMapView!
    var geoButton: UIButton! //Button that will appear on the display
    var pinButton: UIButton! //Button that will appear on the display
    var state: Int = 0
    var bornPin: MKPointAnnotation!                 //Pinned Location
    var currentHomePin: MKPointAnnotation!          //Pinned Location
    var interestingLocationPin: MKPointAnnotation!  //Pinned Location
    
    var locationManager = CLLocationManager.init()
    
    override func loadView() {
        mapView = MKMapView()
        view = mapView //assigning the map to the actual ViewController
        
        //This block creates the 3 map types displayed at the top of the map tab
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"]) //Different map views
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5) //Opacity
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        
        view.addSubview(segmentedControl)
        
        //constraining the map buttons to the top of the display
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController loaded its view.")
        
        /* Chapter 6 Silver */
        
        //allows the app to use location services
        locationManager.requestWhenInUseAuthorization()
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        let geoButton = UIButton(type: .custom)
        let buttonWidth = 40
        
        //Properties to customize and position the user location button on the display
        geoButton.frame = CGRect(x: 15,y: 100,width: buttonWidth, height: buttonWidth)
        geoButton.layer.cornerRadius = 0.5 * geoButton.bounds.size.width //Radius for corners
        geoButton.layer.borderWidth = 0.25
        geoButton.layer.backgroundColor = UIColor.lightGray.cgColor
        geoButton.setTitle("🏠", for: UIControlState()) //This appears inside the button, I chose to use an icon
        geoButton.setTitleColor(UIColor.darkGray, for: UIControlState())
        geoButton.addTarget(self, action: #selector(MapViewController.geoButtonAction(_:)), for: .touchUpInside)
        
        view.addSubview(geoButton)
        
        /* Chapter 6 Gold */
        
        //Greece, NY
        bornPin = MKPointAnnotation() //Declare MKPointAnnotation object
        bornPin.title = "Born Here" //This displays as a label for the pin on the map
        bornPin.coordinate = CLLocationCoordinate2D(latitude: 43.2098, longitude: -77.6931) //places pin on map
        
        //Customization for the born location pin
        let bornPinView = MKPinAnnotationView()
        bornPinView.annotation = bornPin
        bornPinView.pinTintColor = UIColor.green
        bornPinView.animatesDrop = true
        
        mapView.addAnnotation(bornPin)
        
        //Cary, NC
        currentHomePin = MKPointAnnotation()
        currentHomePin.title = "Current Home"
        currentHomePin.coordinate = CLLocationCoordinate2D(latitude: 35.7915, longitude: -78.7811)
        
        //Customization for the current home location pin
        let currentHomePinView = MKPinAnnotationView()
        currentHomePinView.annotation = currentHomePin
        currentHomePinView.pinTintColor = UIColor.blue
        currentHomePinView.animatesDrop = true
        
        mapView.addAnnotation(currentHomePin)
        
        //Walt Disney World, FL
        interestingLocationPin = MKPointAnnotation()
        interestingLocationPin.title = "Interesting spot"
        interestingLocationPin.coordinate = CLLocationCoordinate2D(latitude: 28.3852, longitude: -81.5639)
        
        //Customization for the interesting place pin
        let interestingSpotPinView = MKPinAnnotationView()
        interestingSpotPinView.pinTintColor = UIColor.green
        interestingSpotPinView.animatesDrop = true
        interestingSpotPinView.annotation = interestingLocationPin
        
        mapView.addAnnotation(interestingLocationPin)
        
        //Properties to customize and position the pin button on the display
        pinButton = UIButton(type: .custom)
        pinButton.frame = CGRect(x: 15,y: 200,width: buttonWidth, height: buttonWidth)
        pinButton.layer.cornerRadius = 0.5 * geoButton.bounds.size.width
        pinButton.layer.borderWidth = 0.25
        pinButton.layer.backgroundColor = UIColor.lightGray.cgColor
        pinButton.setTitle("📌", for: UIControlState())
        pinButton.addTarget(self, action: #selector(MapViewController.pinButtonAction(_:)), for: .touchUpInside)
        
        view.addSubview(pinButton)
    }

    //Helper function to change between map views
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    //Helper function to cycle between the 3 pinned locations
    @objc func pinButtonAction(_ sender: UIButton!) {
        switch state {
        case 0:
            state += 1
            setLocation(bornPin)
        case 1:
            state += 1
            setLocation(currentHomePin)
        default:
            state = 0
            setLocation(interestingLocationPin)
        }
    }
    
    //Helper function for pinned locations
    func setLocation(_ place: MKPointAnnotation!) {
        let span = MKCoordinateSpan.init(latitudeDelta: 0.0075, longitudeDelta: 0.0075)
        if place != nil {
            let region = MKCoordinateRegion.init(center: (place.coordinate), span: span)
            mapView.setRegion(region, animated: true) //places pinned location on map
        }
    }
    
    //Helper function to zoom in on the user's location
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let zoomedInCurrentLocation = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500)
        mapView.setRegion(zoomedInCurrentLocation, animated: true)
    }
 
    //Helper function for user location button
    @objc func geoButtonAction(_ sender: UIButton!) {
        let span = MKCoordinateSpan.init(latitudeDelta: 0.0075, longitudeDelta: 0.0075)
        if locationManager.location != nil {
            let region = MKCoordinateRegion.init(center: (locationManager.location?.coordinate)!, span: span)
            mapView.setRegion(region, animated: true) //places user location on map
            //Since this app is being run in a simulator, the user's location will always appear in California
        }
    }
}
