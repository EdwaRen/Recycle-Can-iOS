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


class FirstViewController: UIViewController,CLLocationManagerDelegate, UISearchBarDelegate {
//    @IBOutlet var searchBarMap: UISearchBar!
//
//    @IBOutlet weak var mapView: MKMapView!
//    
//    let locationManager = CLLocationManager()
//    
//    func myLocationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations[0]
//        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
//        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
//        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
////        mapView.setRegion(region, animated : true)
//        self.mapView.showsUserLocation = true;
//        
//    }
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //This stores which of the 3 buttons are pressed on the home screen. If none were pressed, the '-' assumes the user clicked the "map" icon in the navigation bar
        let defaults = UserDefaults.standard
        defaults.set("e", forKey: "selector")
        
        //The local database with the recycling locations across Canada (most of it at least)
        //Each of these are 5 x XXXX dimensional arrays and a separate identifier is needed for each
        var Electronics : [[String]] = Array(repeating: Array(repeating: "0", count: 5), count: 1888)
        var Batteries : [[String]] = Array(repeating: Array(repeating: "0", count: 5), count: 3771)
        var Paint : [[String]] = Array(repeating: Array(repeating: "0", count: 5), count: 1216)
       
        //An array with the selector names that will be used to identify where information is stored in 'defaults'
        //Since each array has 5 columns, and there are 3 arrays, 15 filenames are needed to specifically identify each column.
        var fileNames = ["EName", "ELat", "ELng", "EPhone", "EPost", "BName", "BLat", "BLng", "BPhone", "BPost", "PName", "PLat", "PLng", "PPhone", "PPost"]
        var initCounter = 0;
        
        //Assigns filenames as the key for the separate 1 dimensional arrays.
        while initCounter < 15 {
            if initCounter < 5 {
                do {
                    // This reads a txt file that has all the data.
                    if let path = Bundle.main.path(forResource: fileNames[initCounter], ofType: "txt"){
                        let data = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
                        
                        //This makes text separated by inline a separate entity on the array. So arr[0] = Hello and arr[1] = World, rather than arr[0] = Hello World
                        //Due to an unforeseen text conversion issue, "\n" does not work in this scenario so the alternative "\r" is used and works perfectly
                        Electronics[initCounter%5] = data.components(separatedBy: "\r")
                        let defaults = UserDefaults.standard
                        defaults.set(Electronics[initCounter%5], forKey: fileNames[initCounter])

                    }
                } catch {}
            } else if initCounter < 10 {
                do {
                    if let path = Bundle.main.path(forResource: fileNames[initCounter], ofType: "txt"){
                        let data = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
                        Batteries[initCounter%5] = data.components(separatedBy: "\n")
                        let defaults = UserDefaults.standard
                        defaults.set(Batteries[initCounter%5], forKey: fileNames[initCounter])
                    }
                } catch {}
            } else if initCounter < 15 {
                do {
                    if let path = Bundle.main.path(forResource: fileNames[initCounter], ofType: "txt"){
                        let data = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
                        Paint[initCounter%5] = data.components(separatedBy: "\n")
                        let defaults = UserDefaults.standard
                        defaults.set(Paint[initCounter%5], forKey: fileNames[initCounter])
                    }
                } catch {}
            }
            
            initCounter += 1;
        }

    }
    let defaults = UserDefaults.standard

    @IBAction func electronicsTitleButton(_ sender: Any) {
        //This lets the ViewControllerElec know which button was pressed on the home screen by storing 'e' as the key
        defaults.set("e", forKey: "selector")
        
        //Navigates to the map-bar and changes the tab-bar to represent this change
        tabBarController!.selectedIndex = 1;
    }
    @IBAction func batteriesTitleButton(_ sender: Any) {
        defaults.set("b", forKey: "selector")
        tabBarController!.selectedIndex = 1;
    }
   
    @IBAction func paintTitleButton(_ sender: Any) {
        defaults.set("p", forKey: "selector")
        tabBarController!.selectedIndex = 1;
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



