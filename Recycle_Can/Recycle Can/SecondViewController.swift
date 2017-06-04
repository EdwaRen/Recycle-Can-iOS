//
//  SecondViewController.swift
//  Recycle Can
//
//  Created by - on 2017/06/02.
//  Copyright © 2017 Recycle Canada. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class SecondViewController: UIViewController {

    override func viewDidLoad() {

        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 45.4235937, longitude: -75.7031177, zoom: 10)
        let mapView = GMSMapView.map(withFrame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width , height: self.view.frame.size.height) )   , camera: camera)
        GMSMapView.map
        mapView.isMyLocationEnabled = true
        mapView.setMinZoom(10, maxZoom: 15)
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
        
        
    
        let theHeight = view.frame.size.height
//        let theWidth = view.frame.size.width
        let greyish = UIColor(red:0.81, green:0.80, blue:0.80, alpha:1.0)

        let button = UIButton(frame: CGRect(x: 0, y: theHeight - 120, width: 300, height: 40))
        button.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:0.9)
//        button.setTitle("More",for: .normal)
        button.setTitleColor(UIColor(red:0.21, green:0.20, blue:0.20, alpha:1.0), for: .normal)
        button.addTarget(self, action: #selector(ratingButtonTapped), for: .touchUpInside)
        button.center.x = view.center.x
        button.layer.borderWidth = 1
        button.layer.borderColor = greyish.cgColor
        button.setBackgroundImage(UIImage(named: "MenuBar.png"), for: .normal)
        button.alpha = 0.9
        button.imageView?.contentMode = .scaleAspectFit


        self.view.addSubview(button)
    
        
        
       
        
       
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func ratingButtonTapped() {
        print("Button pressed")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }


}

