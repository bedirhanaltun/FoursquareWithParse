//
//  DetailsViewController.swift
//  FoursquareClone
//
//  Created by Bedirhan Altun on 31.08.2022.
//

import UIKit
import MapKit
import Parse

class DetailsViewController: UIViewController,MKMapViewDelegate {
    
    var chosenPlaceId = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    @IBOutlet weak var placeMapView: MKMapView!
    @IBOutlet weak var placeDescriptionLabel: UILabel!
    @IBOutlet weak var placeTypeLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var detailsImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getEverythingFromParse()
        placeMapView.delegate = self
        
    }
    
    
    
    func getEverythingFromParse(){
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenPlaceId)
        query.findObjectsInBackground { object, error in
            if error != nil{
                self.showError(title: "Error", message: error?.localizedDescription ?? "")
            }
            else{
                if object != nil{
                    if object!.count > 0{
                        let chosenPlaceObject = object![0]
                        if let placeName = chosenPlaceObject.object(forKey: "name") as? String{
                            self.placeNameLabel.text = placeName
                            if let placeType = chosenPlaceObject.object(forKey: "type") as? String{
                                self.placeTypeLabel.text = placeType
                                if let placeDescription = chosenPlaceObject.object(forKey: "description") as? String{
                                    self.placeDescriptionLabel.text = placeDescription
                                    
                                }
                            }
                        }
                        
                        if let placeLatitude = chosenPlaceObject.object(forKey: "latitude") as? String{
                            if let placeLatitudeDouble = Double(placeLatitude){
                                self.chosenLatitude = placeLatitudeDouble
                            }
                        }
                        
                        if let placeLongitude = chosenPlaceObject.object(forKey: "longitude") as? String{
                            if let placeLongitudeDouble = Double(placeLongitude){
                                self.chosenLongitude = placeLongitudeDouble
                            }
                        }
                        
                        if let imageData = chosenPlaceObject.object(forKey: "images") as? PFFileObject{
                            imageData.getDataInBackground { data, error in
                                if error == nil{
                                    if data != nil{
                                        self.detailsImageView.image = UIImage(data: data!)
                                    }
                                    
                                }
                                else{
                                    self.showError(title: "Error", message: error?.localizedDescription ?? "")
                                }
                            }
                        }
                        
                        //Maps
                        
                        let locationMap = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                        let region = MKCoordinateRegion(center: locationMap, span: span)
                        self.placeMapView.setRegion(region, animated: true)
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = locationMap
                        annotation.title = self.placeNameLabel.text
                        annotation.subtitle = self.placeTypeLabel.text
                        self.placeMapView.addAnnotation(annotation)
                    }
                }
            }
        }
        
        
    }
    
    //Navigasyon. Buradan aşağısına çalış.
    
    //Burada yaptığımız işlem yanında çıkan i butonunu yazmaktı.
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        let reuseId = "Pin"
        var pinView = placeMapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil{
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        }
        else{
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    //Burada yaptığımız işlem i butonuna tıklandığında ne yapacağımızdı.
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLongitude != 0.0 && self.chosenLatitude != 0.0{
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                if let placemark = placemarks{
                    if placemark.count > 0{
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.placeNameLabel.text
                        
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }
    
}
