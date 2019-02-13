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
    
    var mapView: MKMapView!
    var geoButton: UIButton!
    var pinButton: UIButton!
    var state: Int = 0
    var homePin: MKPointAnnotation!
    var realHomePin: MKPointAnnotation!
    var futureTravelPin: MKPointAnnotation!
    
    var locationManager = CLLocationManager.init()
    
    override func loadView() {
        mapView = MKMapView()
        view = mapView
        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        locationManager.requestWhenInUseAuthorization()
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        let geoButton = UIButton(type: .custom)
        let buttonWidth = 40
        
        geoButton.frame = CGRect(x: 15,y: 100,width: buttonWidth, height: buttonWidth)
        geoButton.layer.cornerRadius = 0.5 * geoButton.bounds.size.width
        geoButton.layer.borderWidth = 0.25
        geoButton.layer.borderColor = UIColor.darkGray.cgColor
        geoButton.layer.backgroundColor = UIColor.lightGray.cgColor
        geoButton.setTitle("*", for: UIControlState())
        geoButton.setTitleColor(UIColor.darkGray, for: UIControlState())
        geoButton.addTarget(self, action: #selector(MapViewController.geoButtonAction(_:)), for: .touchUpInside)
        
        view.addSubview(geoButton)
        
        homePin = MKPointAnnotation()
        homePin.title = "Born Here"
        homePin.coordinate = CLLocationCoordinate2D(latitude: 43.2098, longitude: -77.6931)
        
        let homePinView = MKPinAnnotationView()
        homePinView.annotation = homePin
        homePinView.pinTintColor = UIColor.green
        homePinView.animatesDrop = true
        
        mapView.addAnnotation(homePin)
    
        realHomePin = MKPointAnnotation()
        realHomePin.title = "Current Home"
        realHomePin.coordinate = CLLocationCoordinate2D(latitude: 35.7915, longitude: -78.7811)
        
        let realHomePinView = MKPinAnnotationView()
        realHomePinView.annotation = realHomePin
        realHomePinView.pinTintColor = UIColor.blue
        realHomePinView.animatesDrop = true
        
        mapView.addAnnotation(realHomePin)
    
        futureTravelPin = MKPointAnnotation()
        futureTravelPin.title = "Interesting spot"
        futureTravelPin.coordinate = CLLocationCoordinate2D(latitude: 28.3852, longitude: -81.5639)
        
        let futureTravelPinView = MKPinAnnotationView()
        futureTravelPinView.pinTintColor = UIColor.green
        futureTravelPinView.animatesDrop = true
        futureTravelPinView.annotation = futureTravelPin
        
        mapView.addAnnotation(futureTravelPin)
        
        
        pinButton = UIButton(type: .custom)
        
        pinButton.frame = CGRect(x: 15,y: 200,width: buttonWidth, height: buttonWidth)
        pinButton.layer.cornerRadius = 0.5 * geoButton.bounds.size.width
        pinButton.layer.borderWidth = 0.25
        pinButton.layer.borderColor = UIColor.darkGray.cgColor
        pinButton.layer.backgroundColor = UIColor.lightGray.cgColor
        pinButton.setTitle("📌", for: UIControlState())
        pinButton.addTarget(self, action: #selector(MapViewController.pinButtonAction(_:)), for: .touchUpInside)
        
        view.addSubview(pinButton)
    }
    
    @objc func pinButtonAction(_ sender: UIButton!) {
        switch state {
        case 0:
            state += 1
            setLocation(homePin)
        case 1:
            state += 1
            setLocation(realHomePin)
        default:
            state = 0
            setLocation(futureTravelPin)
        }
    }
    
    func setLocation(_ place: MKPointAnnotation!){
        let span = MKCoordinateSpan.init(latitudeDelta: 0.0075, longitudeDelta: 0.0075)
        if place != nil{
            let region = MKCoordinateRegion.init(center: (place.coordinate), span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    @objc func geoButtonAction(_ sender: UIButton!) {
        let span = MKCoordinateSpan.init(latitudeDelta: 0.0075, longitudeDelta: 0.0075)
        if locationManager.location != nil {
            let region = MKCoordinateRegion.init(center: (locationManager.location?.coordinate)!, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController loaded its view.")
        
    }
}
