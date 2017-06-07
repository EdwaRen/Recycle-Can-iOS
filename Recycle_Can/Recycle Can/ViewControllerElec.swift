//
//  ViewController.swift
//  MapKitTutorial
//
//  Created by Robert Chen on 12/23/15.
//  Copyright © 2015 Thorn Technologies. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch: class {
    func dropPinZoomIn(_ placemark:MKPlacemark)
}

class ViewControllerElec: UIViewController {
    
    var selectedPin: MKPlacemark?
    var resultSearchController: UISearchController!
    
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {

        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UIMenuController.update), userInfo: nil, repeats: true)


        
        super.viewDidLoad()

        let span = MKCoordinateSpanMake(0.3, 0.3)
        let startLocation = CLLocationCoordinate2DMake(45.4236, -75.7009)

        let region = MKCoordinateRegionMake(startLocation, span)
        mapView.setRegion(region, animated: false)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        if #available(iOS 9.0, *) {
            locationManager.requestLocation()
        } else {
            // Fallback on earlier versions
        }
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        var Electronics : [[String]] = Array(repeating: Array(repeating: "0", count: 5), count: 1888)
        var Battery : [[String]] = Array(repeating: Array(repeating: "0", count: 5), count: 3042)
        var Paint : [[String]] = Array(repeating: Array(repeating: "0", count: 5), count: 943)

        
        var fileNames = ["EName", "ELat", "ELng", "EPhone", "EPost", "BName", "BLat", "BLng", "BPhone", "BPost", "PName", "PLat", "PLng", "PPhone", "PPost"]
        var initCounter = 0;
        
        
        while initCounter < 15 {
            
            
            if initCounter<5{
                if let testArray : AnyObject? = UserDefaults.standard.object(forKey: fileNames[initCounter]) as AnyObject {
                    let readArray : [NSString] = testArray! as! [NSString]
                    Electronics[initCounter%5] = readArray as [String]

                }
            } else if initCounter < 10{
                if let testArray : AnyObject? = UserDefaults.standard.object(forKey: fileNames[initCounter]) as AnyObject {
                    let readArray : [NSString] = testArray! as! [NSString]
                    Battery[initCounter%5] = readArray as [String]
                    
                }
            } else if initCounter < 15{
                if let testArray : AnyObject? = UserDefaults.standard.object(forKey: fileNames[initCounter]) as AnyObject {
                    let readArray : [NSString] = testArray! as! [NSString]
                    Paint[initCounter%5] = readArray as [String]
                    
                }
            }
            

            
            initCounter+=1
        }
        
        
        
            var markCount = 0
            while markCount < 1888 {
                print(markCount)
                let anno = MKPointAnnotation()
                let myLocation = CLLocationCoordinate2DMake(Double(Electronics[1][markCount])!, Double(Electronics[2][markCount])!)
                anno.coordinate = myLocation
                anno.title = Electronics[0][markCount]
                anno.subtitle = "Phone: " + Electronics[3][markCount] + "\n" + "Postal Code: " + Electronics[4][markCount]
                self.mapView.addAnnotation(anno)
                
                markCount += 1
            }
            
                
        
    }
    func highlightButton(button: UIButton) {
        button.isHighlighted = true
        button.isSelected = true
        button.backgroundColor = UIColor.white
    }
    func update() {
        let selected: String = (UserDefaults.standard.object(forKey: "selector") as AnyObject) as! String
        let defaults = UserDefaults.standard
        defaults.set("-", forKey: "selector")
        if selected == "e" || selected == "b" || selected == "p" {
            mapView.removeAnnotations(mapView.annotations)

            var Electronics : [[String]] = Array(repeating: Array(repeating: "0", count: 5), count: 1888)
            var Battery : [[String]] = Array(repeating: Array(repeating: "0", count: 5), count: 3042)
            var Paint : [[String]] = Array(repeating: Array(repeating: "0", count: 5), count: 943)
            var fileNames = ["EName", "ELat", "ELng", "EPhone", "EPost", "BName", "BLat", "BLng", "BPhone", "BPost", "PName", "PLat", "PLng", "PPhone", "PPost"]
            var initCounter = 0;
            while initCounter < 15 {
                if initCounter<5{
                    if let testArray : AnyObject? = UserDefaults.standard.object(forKey: fileNames[initCounter]) as AnyObject {
                        let readArray : [NSString] = testArray! as! [NSString]
                        Electronics[initCounter%5] = readArray as [String]
                    }
                } else if initCounter < 10{
                    if let testArray : AnyObject? = UserDefaults.standard.object(forKey: fileNames[initCounter]) as AnyObject {
                        let readArray : [NSString] = testArray! as! [NSString]
                        Battery[initCounter%5] = readArray as [String]
                    }
                } else if initCounter < 15{
                    if let testArray : AnyObject? = UserDefaults.standard.object(forKey: fileNames[initCounter]) as AnyObject {
                        let readArray : [NSString] = testArray! as! [NSString]
                        Paint[initCounter%5] = readArray as [String]
                    }
                }
                initCounter+=1
            }

            
            if selected as! String == "e" {
                var markCount = 0
                buttonClicked(sender: eButton)
                while markCount < 1888 {
                    print(markCount)
                    let anno = MKPointAnnotation()
                    let myLocation = CLLocationCoordinate2DMake(Double(Electronics[1][markCount])!, Double(Electronics[2][markCount])!)
                    anno.coordinate = myLocation
                    anno.title = Electronics[0][markCount]
                    anno.subtitle = "Phone: " + Electronics[3][markCount] + "\n" + "Postal Code: " + Electronics[4][markCount]
                    self.mapView.addAnnotation(anno)
                    
                    markCount += 1
                }
                
            } else if selected as! String == "b" {
                buttonClicked(sender: bButton)

                var markCount = 0
                while markCount < 3042 {
                    print(markCount)
                    print(Battery[1][markCount])
                    let anno = MKPointAnnotation()
                    let myLocation = CLLocationCoordinate2DMake(Double(Battery[1][markCount])!, Double(Battery[2][markCount])!)
                    anno.coordinate = myLocation
                    anno.title = Battery[0][markCount]
                    anno.subtitle = "Phone: " + Battery[3][markCount] + "\n" + "Postal Code: " + Battery[4][markCount]
                    self.mapView.addAnnotation(anno)
                    
                    markCount += 1
                }
            } else if selected as! String == "p" {
                buttonClicked(sender: pButton)

                var markCount = 0
                while markCount < 942 {
                    print(markCount)
                    let anno = MKPointAnnotation()
                    let myLocation = CLLocationCoordinate2DMake(Double(Paint[1][markCount])!, Double(Paint[2][markCount])!)
                    anno.coordinate = myLocation
                    anno.title = Paint[0][markCount]
                    anno.subtitle = "Phone: " + Paint[3][markCount] + "\n" + "Postal Code: " + Paint[4][markCount]
                    self.mapView.addAnnotation(anno)
                    
                    markCount += 1
                }
            }
        }
        
    }
    
    
    @IBOutlet weak var eButton: UIButton!
    @IBOutlet weak var bButton: UIButton!
    @IBOutlet weak var pButton: UIButton!
    
    func buttonClicked(sender:UIButton)
    {
        eButton.backgroundColor = UIColor.white
        bButton.backgroundColor = UIColor.white
        pButton.backgroundColor = UIColor.white
        
        eButton.setTitleColor(UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0), for: .normal)
        bButton.setTitleColor(UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0), for: .normal)
        pButton.setTitleColor(UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0), for: .normal)

        sender.backgroundColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
        sender.setTitleColor(UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0), for: .selected)
        sender.setTitleColor(UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0), for: .normal)

    }
   
//    lazy var buttons: [UIButton] = [self.ewasteButton, self.paintButton, self.batteryButton]

    
    
    @IBAction func ewasteButton(_ sender: Any) {
        buttonClicked(sender: sender as! UIButton)
        mapView.removeAnnotations(mapView.annotations)
        var Electronics : [[String]] = Array(repeating: Array(repeating: "0", count: 5), count: 1888)
        var initCounter = 0;
        var fileNames = ["EName", "ELat", "ELng", "EPhone", "EPost"]
        
        while initCounter < 5 {
            if initCounter<5{
                if let testArray : AnyObject? = UserDefaults.standard.object(forKey: fileNames[initCounter]) as AnyObject {
                    let readArray : [NSString] = testArray! as! [NSString]
                    Electronics[initCounter%5] = readArray as [String]
                }
            }
            initCounter+=1
        }
        var markCount = 0
        while markCount < 1888 {
            
            let anno = MKPointAnnotation()
            let myLocation = CLLocationCoordinate2DMake(Double(Electronics[1][markCount])!, Double(Electronics[2][markCount])!)
            anno.coordinate = myLocation
            anno.title = Electronics[0][markCount]
            anno.subtitle = "Phone: " + Electronics[3][markCount] + "\n" + "Postal Code: " + Electronics[4][markCount]
            self.mapView.addAnnotation(anno)
            markCount += 1
        }
    }
    
    @IBAction func paintButton(_ sender: Any) {
        buttonClicked(sender: sender as! UIButton)

        mapView.removeAnnotations(mapView.annotations)
        var Paint : [[String]] = Array(repeating: Array(repeating: "0", count: 5), count: 943)
        var initCounter = 0;
        var fileNames = ["PName", "PLat", "PLng", "PPhone", "PPost"]
        
        while initCounter < 5 {
            if initCounter<5{
                if let testArray : AnyObject? = UserDefaults.standard.object(forKey: fileNames[initCounter]) as AnyObject {
                    let readArray : [NSString] = testArray! as! [NSString]
                    Paint[initCounter%5] = readArray as [String]
                }
            }
            initCounter+=1
        }
        var markCount = 0
        while markCount < 942 {
            
            let anno = MKPointAnnotation()
            let myLocation = CLLocationCoordinate2DMake(Double(Paint[1][markCount])!, Double(Paint[2][markCount])!)
            anno.coordinate = myLocation
            anno.title = Paint[0][markCount]
            anno.subtitle = "Phone: " + Paint[3][markCount] + "\n" + "Postal Code: " + Paint[4][markCount]
            self.mapView.addAnnotation(anno)
            markCount += 1
        }
        
    }

    
    @IBAction func batteryButton(_ sender: Any) {
        buttonClicked(sender: sender as! UIButton)

        mapView.removeAnnotations(mapView.annotations)
        var Batteries : [[String]] = Array(repeating: Array(repeating: "0", count: 5), count: 3042)
        var initCounter = 0;
        var fileNames = ["BName", "BLat", "BLng", "BPhone", "BPost", "PName", "PLat", "PLng", "PPhone", "PPost"]

        while initCounter < 5 {
            if initCounter<5{
                if let testArray : AnyObject? = UserDefaults.standard.object(forKey: fileNames[initCounter]) as AnyObject {
                    let readArray : [NSString] = testArray! as! [NSString]
                    Batteries[initCounter%5] = readArray as [String]
                }
            }
            initCounter+=1
        }
        var markCount = 0
        while markCount < 3042 {
            print(markCount)
            let anno = MKPointAnnotation()
            let myLocation = CLLocationCoordinate2DMake(Double(Batteries[1][markCount])!, Double(Batteries[2][markCount])!)
            anno.coordinate = myLocation
            anno.title = Batteries[0][markCount]
            anno.subtitle = "Phone: " + Batteries[3][markCount] + "\n" + "Postal Code: " + Batteries[4][markCount]
            self.mapView.addAnnotation(anno)
            markCount += 1
        }
        
        


        print("button works")
    }
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//
//    }
   
    
}




extension ViewControllerElec : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            if #available(iOS 9.0, *) {
                locationManager.requestLocation()
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: false)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
}

extension ViewControllerElec: HandleMapSearch {
    
    func dropPinZoomIn(_ placemark: MKPlacemark){

        // cache the pin
        selectedPin = placemark
        // clear existing pins
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
}


extension ViewControllerElec : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{

        guard !(annotation is MKUserLocation) else { return nil }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        if #available(iOS 9.0, *) {
            pinView?.pinTintColor = UIColor.orange
        } else {
            // Fallback on earlier versions
        }
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "MenuBar.png"), for: UIControlState())
//        let defaults = UserDefaults.standard
//        defaults.set(pinView?.annotation?.coordinate.latitude, forKey: "lat")
//        defaults.set(pinView?.annotation?.coordinate.longitude, forKey: "lng")
//        let selectedLoc = pinView?.annotation
//        print ( "Test\n")
//        let selectedPlacemark = MKPlacemark(coordinate: (selectedLoc?.coordinate)!, addressDictionary: nil)
//        selectedPin = selectedPlacemark
        button.accessibilityHint = String(Double(annotation.coordinate.latitude))
        button.accessibilityLabel = String(Double(annotation.coordinate.longitude))
        button.accessibilityValue = annotation.title!
        
        button.addTarget(self, action: #selector(ViewControllerElec.getDirections(sender:)), for:.touchUpInside)
       
        let subtitleView = UILabel()
        subtitleView.font = subtitleView.font.withSize(12)
        subtitleView.numberOfLines = 0
        subtitleView.text = annotation.subtitle!
        pinView!.detailCalloutAccessoryView = subtitleView

        
        pinView?.leftCalloutAccessoryView = button
        
        
        
        return pinView
    }
    
    func getDirections(sender: UIButton){

        //        guard let selectedPin = selectedPin else { return }
        //        let mapItem = MKMapItem(placemark: selectedPin)
        //        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        //        mapItem.openInMaps(launchOptions: launchOptions)
        print(Double(sender.accessibilityHint!))
        print(Double(sender.accessibilityLabel!))

        let latitude: CLLocationDegrees = Double(sender.accessibilityHint!)!
        let longitude: CLLocationDegrees = Double(sender.accessibilityLabel!)!
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [ MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = sender.accessibilityValue
        mapItem.openInMaps(launchOptions: options)

        
        //        var goLatitude:Double
        //        var goLongitude: Double
        
        //        let goLongitude : AnyObject? = UserDefaults.standard.object(forKey: "lng") as AnyObject
        //        let goLatitude : AnyObject? = UserDefaults.standard.object(forKey: "lat") as AnyObject
        //
        //            print ("Getting direcitons")
        
        //        print ("Getting direcitons")
        //
        //        let coordinate = CLLocationCoordinate2DMake(goLatitude as! CLLocationDegrees, goLongitude as! CLLocationDegrees)
        //        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        //        mapItem.name = "Recycle Can Location"
        //        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        
    }
}



