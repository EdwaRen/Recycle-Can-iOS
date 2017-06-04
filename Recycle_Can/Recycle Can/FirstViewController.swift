//
//  FirstViewController.swift
//  Recycle Can
//
//  Created by - on 2017/06/02.
//  Copyright © 2017 Recycle Canada. All rights reserved.
//

import UIKit
//import GoogleMaps
import MapKit
import CoreLocation


class FirstViewController: UIViewController , CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated : true)
        self.mapView.showsUserLocation = true;
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var Electronics : [[String]] = Array(repeating: Array(repeating: "0", count: 5), count: 5178)
//        var Batteries : [[String]] = Array(repeating: Array(repeating: "0", count: 5), count: 8855)
//        var Paint : [[String]] = Array(repeating: Array(repeating: "0", count: 5), count: 943)
//
//        
//        var fileNames = ["EName", "ELat", "ELng", "EPhone", "EPost", "BName", "BLat", "BLng", "BPhone", "BPost", "PName", "PLat", "PLng", "PPhone", "PPost"]
//        var initCounter = 0;
//        while initCounter < 15 {
// 
//            if initCounter < 5 {
//                do {
//                    // This solution assumes  you've got the file in your bundle
//                    if let path = Bundle.main.path(forResource: fileNames[initCounter], ofType: "txt"){
//                        let data = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
//                        Electronics[initCounter%5] = data.components(separatedBy: "\n")
//                        let defaults = UserDefaults.standard
//                        defaults.set(Electronics[initCounter%5], forKey: fileNames[initCounter])
//
//                    }
//                } catch {}
//            } else if initCounter < 10 {
//                do {
//                    // This solution assumes  you've got the file in your bundle
//                    if let path = Bundle.main.path(forResource: fileNames[initCounter], ofType: "txt"){
//                        let data = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
//                        Batteries[initCounter%5] = data.components(separatedBy: "\n")
//                        let defaults = UserDefaults.standard
//                        defaults.set(Batteries[initCounter%5], forKey: fileNames[initCounter])
//                    }
//                } catch {}
//            } else if initCounter < 15 {
//                do {
//                    // This solution assumes  you've got the file in your bundle
//                    if let path = Bundle.main.path(forResource: fileNames[initCounter], ofType: "txt"){
//                        let data = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
//                        Paint[initCounter%5] = data.components(separatedBy: "\n")
//                        let defaults = UserDefaults.standard
//                        defaults.set(Paint[initCounter%5], forKey: fileNames[initCounter])
//                    }
//                } catch {}
//            }
//            
//            initCounter += 1;
//        }
//        
        
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
    
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

