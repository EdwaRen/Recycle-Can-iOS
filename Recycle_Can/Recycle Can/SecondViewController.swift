//
//  SecondViewController.swift
//  Recycle Can
//
//  Created by - on 2017/06/02.
//  Copyright © 2017 Recycle Canada. All rights reserved.
//

import UIKit
import GoogleMaps

class SecondViewController: UIViewController {

    override func viewDidLoad() {

        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 45.4235937, longitude: -75.7031177, zoom: 10)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.isMyLocationEnabled = true
        self.view = mapView
        
        
        var Electronics : [[String]] = Array(repeating: Array(repeating: "0", count: 5), count: 5178)
        var Batteries : [[String]] = Array(repeating: Array(repeating: "0", count: 5), count: 8855)
        var Paint : [[String]] = Array(repeating: Array(repeating: "0", count: 5), count: 943)

        
        var fileNames = ["EName", "ELat", "ELng", "EPhone", "EPost", "BName", "BLat", "BLng", "BPhone", "BPost", "PName", "PLat", "PLng", "PPhone", "PPost"]
        var initCounter = 0;
        
        
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
        
        
        while markCount < 5178 {
            
            //Setup map view
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: Double(Electronics[1][markCount])!, longitude: Double(Electronics[2][markCount])!)
            marker.title = Electronics[0][markCount]
            marker.snippet =  "Phone:" + Electronics[3][markCount] + "\nPostal Code:" + Electronics[4][markCount]
            marker.map = mapView
            
            markCount += 1
        }
    
        
        
       
        
       
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

