////
////  ViewController.swift
////  MapKitTutorial
////
////  Created by Robert Chen on 12/23/15.
////  Copyright © 2015 Thorn Technologies. All rights reserved.
////
//
//import UIKit
//import MapKit
//
//
//
//class ViewControllerBat: UIViewController {
//    
//    var selectedPin: MKPlacemark?
//    var resultSearchController: UISearchController!
//    
//    let locationManager = CLLocationManager()
//    
//   
//    
//    @IBOutlet weak var mapView: MKMapView!
//    override func viewDidLoad() {
//        print("Hi initial hi\n")
//        
//        
//        
//        
//        super.viewDidLoad()
//        let span = MKCoordinateSpanMake(0.05, 0.05)
//        let startLocation = CLLocationCoordinate2DMake(45.4236, -75.7009)
//        
//        let region = MKCoordinateRegionMake(startLocation, span)
//        mapView.setRegion(region, animated: false)
//        
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        if #available(iOS 9.0, *) {
//            locationManager.requestLocation()
//        } else {
//            // Fallback on earlier versions
//        }
//        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
//        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
//        resultSearchController.searchResultsUpdater = locationSearchTable
//        let searchBar = resultSearchController!.searchBar
//        searchBar.sizeToFit()
//        searchBar.placeholder = "Search for places"
//        navigationItem.titleView = resultSearchController?.searchBar
//        resultSearchController.hidesNavigationBarDuringPresentation = false
//        resultSearchController.dimsBackgroundDuringPresentation = true
//        definesPresentationContext = true
//        locationSearchTable.mapView = mapView
//        locationSearchTable.handleMapSearchDelegate = self
//        
//        var Electronics : [[String]] = Array(repeating: Array(repeating: "0", count: 5), count: 5178)
//        var Batteries : [[String]] = Array(repeating: Array(repeating: "0", count: 5), count: 8855)
//        var Paint : [[String]] = Array(repeating: Array(repeating: "0", count: 5), count: 1216)
//        
//        
//        var fileNames = ["EName", "ELat", "ELng", "EPhone", "EPost", "BName", "BLat", "BLng", "BPhone", "BPost", "PName", "PLat", "PLng", "PPhone", "PPost"]
//        var initCounter = 0;
//        
//        
//        while initCounter < 5 {
//            
//            
//            if initCounter<5{
//                if let testArray : AnyObject? = UserDefaults.standard.object(forKey: fileNames[initCounter]) as AnyObject {
//                    let readArray : [NSString] = testArray! as! [NSString]
//                    Electronics[initCounter%5] = readArray as [String]
//                    print("Hi\n")
//                    
//                }
//                print("Hi\n")
//                
//            }
//            print("Hi\n")
//            
//            
//            initCounter+=1
//        }
//        
//        var markCount = 0
//        //
//        //
//        while markCount < 5178 {
//            print("Hi\n")
//            
//            
//            let anno = MKPointAnnotation()
//            let myLocation = CLLocationCoordinate2DMake(Double(Electronics[1][markCount])!, Double(Electronics[2][markCount])!)
//            anno.coordinate = myLocation
//            anno.title = Electronics[0][markCount]
//            anno.subtitle = Electronics[3][markCount]
//            
//            //            let reuseId = "pin"
//            //            var pinView = MKPinAnnotationView(annotation: anno, reuseIdentifier: reuseId)
//            //
//            //            let smallSquare = CGSize(width: 30, height: 30)
//            //            let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
//            //            button.setBackgroundImage(UIImage(named: "MenuBar.png"), for: UIControlState())
//            //
//            //
//            //            button.accessibilityHint = Electronics[1][markCount]
//            //            button.accessibilityLabel = Electronics[2][markCount]
//            //
//            //            button.addTarget(self, action: #selector(self.getDirections(button:)), for: .touchUpInside)
//            //
//            //            pinView.canShowCallout = true
//            //            pinView.leftCalloutAccessoryView = button
//            
//            
//            
//            //            let span = MKCoordinateSpanMake(0.1, 0.1)
//            //            let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
//            self.mapView.addAnnotation(anno)
//            
//            markCount += 1
//        }
//        //                self.mapView.setRegion(region, animated: true)
//        
//        
//        
//        
//    }
//    
//    
//    
//    
//    
//    
//    
//}
//
//extension ViewControllerBat : CLLocationManagerDelegate {
//    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            if #available(iOS 9.0, *) {
//                locationManager.requestLocation()
//            } else {
//                // Fallback on earlier versions
//            }
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else { return }
//        let span = MKCoordinateSpanMake(0.1, 0.1)
//        let region = MKCoordinateRegion(center: location.coordinate, span: span)
//        mapView.setRegion(region, animated: false)
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("error:: \(error)")
//    }
//    
//}
//
//extension ViewControllerBat: HandleMapSearch {
//    
//    func dropPinZoomIn(_ placemark: MKPlacemark){
//        print("Hi\n")
//        
//        // cache the pin
//        selectedPin = placemark
//        // clear existing pins
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = placemark.coordinate
//        annotation.title = placemark.name
//        
//        if let city = placemark.locality,
//            let state = placemark.administrativeArea {
//            annotation.subtitle = "\(city) \(state)"
//        }
//        
//        mapView.addAnnotation(annotation)
//        let span = MKCoordinateSpanMake(0.05, 0.05)
//        let region = MKCoordinateRegionMake(placemark.coordinate, span)
//        mapView.setRegion(region, animated: false)
//    }
//    
//}
//
//
//extension ViewControllerBat : MKMapViewDelegate {
//    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
//        print("Hi this is the mapview\n")
//        
//        guard !(annotation is MKUserLocation) else { return nil }
//        let reuseId = "pin"
//        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
//        if pinView == nil {
//            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//        }
//        if #available(iOS 9.0, *) {
//            pinView?.pinTintColor = UIColor.orange
//        } else {
//            // Fallback on earlier versions
//        }
//        pinView?.canShowCallout = true
//        let smallSquare = CGSize(width: 30, height: 30)
//        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
//        button.setBackgroundImage(UIImage(named: "MenuBar.png"), for: UIControlState())
//        //        let defaults = UserDefaults.standard
//        //        defaults.set(pinView?.annotation?.coordinate.latitude, forKey: "lat")
//        //        defaults.set(pinView?.annotation?.coordinate.longitude, forKey: "lng")
//        //        let selectedLoc = pinView?.annotation
//        //        print ( "Test\n")
//        //        let selectedPlacemark = MKPlacemark(coordinate: (selectedLoc?.coordinate)!, addressDictionary: nil)
//        //        selectedPin = selectedPlacemark
//        button.accessibilityHint = String(Double(annotation.coordinate.latitude))
//        button.accessibilityLabel = String(Double(annotation.coordinate.longitude))
//        button.accessibilityValue = annotation.title!
//        
//        button.addTarget(self, action: #selector(ViewControllerBat.getDirections(sender:)), for:.touchUpInside)
//        
//        
//        
//        
//        pinView?.leftCalloutAccessoryView = button
//        
//        
//        
//        return pinView
//    }
//    
//    func getDirections(sender: UIButton){
//        print("Hi getting directions \n")
//        
//        //        guard let selectedPin = selectedPin else { return }
//        //        let mapItem = MKMapItem(placemark: selectedPin)
//        //        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
//        //        mapItem.openInMaps(launchOptions: launchOptions)
//        print(Double(sender.accessibilityHint!))
//        print(Double(sender.accessibilityLabel!))
//        
//        print("latitude printed \n")
//        let latitude: CLLocationDegrees = Double(sender.accessibilityHint!)!
//        let longitude: CLLocationDegrees = Double(sender.accessibilityLabel!)!
//        
//        let regionDistance:CLLocationDistance = 10000
//        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
//        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
//        let options = [ MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
//        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
//        let mapItem = MKMapItem(placemark: placemark)
//        mapItem.name = sender.accessibilityValue
//        mapItem.openInMaps(launchOptions: options)
//        print("Hi Pls do not crash\n")
//        
//        
//        //        var goLatitude:Double
//        //        var goLongitude: Double
//        
//        //        let goLongitude : AnyObject? = UserDefaults.standard.object(forKey: "lng") as AnyObject
//        //        let goLatitude : AnyObject? = UserDefaults.standard.object(forKey: "lat") as AnyObject
//        //
//        //            print ("Getting direcitons")
//        
//        //        print ("Getting direcitons")
//        //
//        //        let coordinate = CLLocationCoordinate2DMake(goLatitude as! CLLocationDegrees, goLongitude as! CLLocationDegrees)
//        //        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
//        //        mapItem.name = "Recycle Can Location"
//        //        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
//        
//    }
//}
//
//
//
