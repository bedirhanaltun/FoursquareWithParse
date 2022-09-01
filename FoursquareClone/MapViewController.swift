//
//  MapViewController.swift
//  FoursquareClone
//
//  Created by Bedirhan Altun on 31.08.2022.
//

import UIKit
import MapKit
import Parse

class MapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    let currentUserLocation = CLLocationManager()
    
    @IBOutlet weak var mapKitView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveMap))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))
        
        mapKitView.delegate = self
        currentUserLocation.delegate = self
        currentUserLocation.desiredAccuracy = kCLLocationAccuracyBest
        currentUserLocation.requestWhenInUseAuthorization()
        currentUserLocation.startUpdatingLocation()
        
        
        let pinRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(takeLocationFromUser(gestureRecognizer:)))
        pinRecognizer.minimumPressDuration = 3
        mapKitView.addGestureRecognizer(pinRecognizer)
        
    }
    
    @objc func takeLocationFromUser(gestureRecognizer : UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizer.State.began{
            let touched = gestureRecognizer.location(in: mapKitView)
            let coordinates = mapKitView.convert(touched, toCoordinateFrom: mapKitView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = Places.instance.placeName
            annotation.subtitle = Places.instance.placeType
            
            mapKitView.addAnnotation(annotation)
            
            Places.instance.placeLatitude = String(coordinates.latitude)
            Places.instance.placeLongitude = String(coordinates.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: location, span: span)
        mapKitView.setRegion(region, animated: true)
        
    }
    
    @objc private func backButtonClicked(){
        dismiss(animated: true)
    }

    @objc private func saveMap(){
        
        let singletonForPlaces = Places.instance
        
        let parseObjc = PFObject(className: "Places")
        parseObjc["name"] = singletonForPlaces.placeName
        parseObjc["type"] = singletonForPlaces.placeType
        parseObjc["description"] = singletonForPlaces.placeDescription
        parseObjc["latitude"] = singletonForPlaces.placeLatitude
        parseObjc["longitude"] = singletonForPlaces.placeLongitude
        
        //Fotoğrafı dataya çeviriyoruz.
        
        if let imageData = singletonForPlaces.placeImage.jpegData(compressionQuality: 0.5){
            parseObjc["images"] = PFFileObject(name: "image.jpg", data: imageData)
        }
        
        parseObjc.saveInBackground { savedSuccess, savedError in
            if savedError != nil{
                self.showError(title: "Error", message: "You don't saved successfully.")
            }
            else{
                self.performSegue(withIdentifier: "toTableView", sender: nil)
            }
        }
    }

}
