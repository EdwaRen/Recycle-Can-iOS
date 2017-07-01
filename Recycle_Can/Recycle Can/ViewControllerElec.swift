//
//  ViewController.swift
//  MapKitTutorial
//
//  Created by Robert Chen on 12/23/15.
//  Copyright © 2015 Thorn Technologies. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

//Protocol to go to the location entered in by the user
protocol HandleMapSearch: class {
    func dropPinZoomIn(_ placemark:MKPlacemark)
}
var myCount = 0
var myUserLatitude: Double = 1000.0
var myUserLongitude: Double = 1000.0

var Electronics : [[String]] = Array(repeating: Array(repeating: "0", count: 5), count: 1888)
var Battery : [[String]] = Array(repeating: Array(repeating: "0", count: 5), count: 3771)
var Paint : [[String]] = Array(repeating: Array(repeating: "0", count: 5), count: 1230)
var overRect : MKMapRect = MKMapRectMake(0, 0, 0, 0)

class ViewControllerElec: UIViewController {
    var locationArray: [(textField: UITextField?, mapItem: MKMapItem?)]!
    
    @IBOutlet weak var distanceBackground: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var eButton: UIButton! //The three materials buttons can now be referenced (ewaste, battery, paint)
    @IBOutlet weak var bButton: UIButton!
    @IBOutlet weak var pButton: UIButton!
    
    @IBOutlet weak var searchBlank: UIImageView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    var selectedPin: MKPlacemark?
    var resultSearchController: UISearchController!
    let locationManager = CLLocationManager()
    
    var closestPinDistance = [99999999.9, 99999999.9, 9999999.9]
    var closestPinCoordinates = [CLLocationCoordinate2D](repeating: CLLocationCoordinate2DMake(0, 0), count: 3)
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        
        
        
        //Due to unforeseen errors resulting from updating data between view controllers, this bypass was used to simply check for updates every 100 miliseconds.
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UIMenuController.update), userInfo: nil, repeats: true)
//        _ = Timer.scheduledTimer(timeInterval: 9, target: self, selector: #selector(noLocation), userInfo: nil, repeats: false)


        
        super.viewDidLoad()
        mapView.showsUserLocation = true

        let defaults = UserDefaults.standard
        defaults.set(1000.0, forKey: "userLatitude")         //Creates a storage check for the user's latitude. Since a latitude of 1000 is impossible, we know that something is wrong if it is still 1000.0

        
        createLocationManagerSearchTable() //Initializes the location manager as well as the search table
        
        
        
    }
    
    func createLocationManagerSearchTable() {
        //Sets the zoom level and location of the initial map (parliament hill)
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let startLocation = CLLocationCoordinate2DMake(45.4236, -75.7009)
        let region = MKCoordinateRegionMake(startLocation, span)
        mapView.setRegion(region, animated: false)
        mapView.delegate = self
        
        //Setting up the location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        //        locationManager.startUpdatingLocation()
        
        switch CLLocationManager.authorizationStatus() {
        case  .restricted, .denied:
            realFadeOut()
            let alertController = UIAlertController(
                title: "Location Access Disabled",
                message: "To go to your current location, please open this app in settings under 'privacy' and set location access to 'While Using the App'.",
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url as URL)
                }
            }
            alertController.addAction(openAction)
            
            self.present(alertController, animated: true, completion: nil)
            realFadeOut()
        default: ()
            
        }
        
        
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
        searchBar.placeholder = "Set Your Postal Code"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        
        
    }
    
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var cButton: UIButton!
    @IBAction func cancelOverlay(_ sender: Any) {

        removeOverlays()        //simply cancels all overlays
        
    }
    @IBAction func expandOverlay(_ sender: Any) {
        let r = self.mapView.mapRectThatFits(overRect, edgePadding: UIEdgeInsetsMake(100, 70, 100, 70))
        self.mapView.setRegion(MKCoordinateRegionForMapRect(r), animated: true)
    }
    @IBAction func expandOverdssadlay(_ sender: Any) {
//        let r = self.mapView.mapRectThatFits(overRect, edgePadding: UIEdgeInsetsMake(150, 100, 150, 100))
//        self.mapView.setRegion(MKCoordinateRegionForMapRect(r), animated: true)
        
    }
    @IBAction func userLocationButton(_ sender: Any) {
        switch CLLocationManager.authorizationStatus() {
        case .restricted, .denied:
            realFadeOut()

            let alertController = UIAlertController(
                title: "Location Access Disabled",
                message: "To go to your current location, please open this app in settings under 'privacy' and set location access to 'Always'.",
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url as URL)
                }
            }
            alertController.addAction(openAction)
            
            
            self.present(alertController, animated: true, completion: nil)
        default: ()
            
        }
        
        let userCoordinates: CLLocationCoordinate2D
        
        
        if myUserLatitude != 1000.0 { //This means the user's coordinates have been discovered and the map is now heading towards it
            userCoordinates = CLLocationCoordinate2D(latitude: myUserLatitude, longitude: myUserLongitude)
            
            if eButton.backgroundColor != UIColor.white { //Heads to the user's coordinates but re-sizes the map to show the closest nearby recycling center
                findClosestEverything(recycleType: "e")
            } else if bButton.backgroundColor != UIColor.white {
                findClosestEverything(recycleType: "b")
            } else if pButton.backgroundColor != UIColor.white {
                findClosestEverything(recycleType: "p")
            }
            
            
        }
        
        
        
        
        
        
    }
    
    private func userDistance(from point: MKPointAnnotation) -> Double? { //Finds the user's distance from a particular MKPointAnnotation
        
        guard let userLocation = mapView.userLocation.location else {
            return nil // User location unknown!
        }
        let pointLocation = CLLocation(
            latitude:  point.coordinate.latitude,
            longitude: point.coordinate.longitude
        )
        return userLocation.distance(from: pointLocation)
    }
    
    func fadeOut() {//This simply adds a delay until the called imageview fades out. This is so that the image still displays for a full second before fading out rather than starting immediately
        
        
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(realFadeOut), userInfo: nil, repeats: false)
        
        
        
    }
    
    func realFadeOut() { //Animates an imageview fadeout
        
        
        UIView.animate(withDuration: 1, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.loading.alpha = 0
            self.searchBlank.alpha = 0

        }, completion: nil)
        
    }
    
    func highlightButton(button: UIButton) { //Highlights one of the three  upper materials buttons
        
        button.isHighlighted = true
        button.isSelected = true
    }
    
    func findClosestEverything(recycleType: String) { //Finds the closest pin for different materials
        
        if myUserLatitude != 1000.0 { //Makes sure the user locaiton is enabled so we have two locations to compare
            
//            let sourceCoord = self.mapView.userLocation.coordinate //The user's coordinates
//            _ = CLLocation(latitude: sourceCoord.latitude, longitude: sourceCoord.longitude)
            
            if recycleType == "e" {
                let doubleArray1 = Electronics[1].map { Double($0) ?? 0 } //Converts the string Electronics[1] array into an array of doubles so that it can be used as a coordinate location
                let doubleArray2 = Electronics[2].map { Double($0) ?? 0 }

                findThisDistance(latitudes: doubleArray1, longitudes: doubleArray2, type: 0)
            } else if recycleType == "b" {
                let doubleArray1 = Battery[1].map { Double($0) ?? 0 }
                let doubleArray2 = Battery[2].map { Double($0) ?? 0 }
                
                findThisDistance(latitudes: doubleArray1, longitudes: doubleArray2, type: 1)
            } else if recycleType == "p" {
                let doubleArray1 = Paint[1].map { Double($0) ?? 0 }
                let doubleArray2 = Paint[2].map { Double($0) ?? 0 }
                
                findThisDistance(latitudes: doubleArray1, longitudes: doubleArray2, type: 2)
            }
            
            
        }
    }
    func findThisDistance(latitudes: [Double], longitudes: [Double], type: Int) { //FInds the closest distance for a specific material
        
        let sourceCoord = self.mapView.userLocation.coordinate //The user's coordinates and hence location
        let sourceLocation = CLLocation(latitude: sourceCoord.latitude, longitude: sourceCoord.longitude)
        
        var markCount = 0
        while markCount < (latitudes.count-1) { //Iterates through the entire array. Latitutes is the same length as longitudes so either works fine here
            
            let myLocation = CLLocationCoordinate2DMake(Double(latitudes[markCount]), Double(longitudes[markCount])) //MyLocation and destLocation are two locations to compare distances
            let destLocation = CLLocation(latitude: myLocation.latitude, longitude: myLocation.longitude)
            
            
            if let distance:Double = sourceLocation.distance(from: destLocation) { //Calculates distance between two locations
                
                if distance < (closestPinDistance[type]) { //Checks if this is the closest location by comparing it with the current closest location. If it is then it replaces it
                    
                    closestPinDistance[type] = distance
                    closestPinCoordinates[type] = destLocation.coordinate
                    
                }
            }
            markCount+=1
        }
        let p1: MKMapPoint = MKMapPointForCoordinate (sourceCoord) //Creates two mkmappoints to make a sizing rectangle out of them
        let p2: MKMapPoint = MKMapPointForCoordinate (closestPinCoordinates[type])

        
        let rect: MKMapRect = MKMapRectMake(fmin(p1.x,p2.x), fmin(p1.y,p2.y), fabs(p1.x-p2.x), fabs(p1.y-p2.y)) //Makes a perfect rectangle with two previous mkmappoints on the very edge
        
        let r = self.mapView.mapRectThatFits(rect, edgePadding: UIEdgeInsetsMake(200, 130, 200, 130)) //Adds insets so that there is a buffer and the two mkmappoints (annotation and user location) are clearly visible
        
        self.mapView.setRegion(MKCoordinateRegionForMapRect(r), animated: true)

    }
    
    func noLocation() {
        realFadeOut()
        switch CLLocationManager.authorizationStatus() {
        case .restricted, .denied:
            let alertController = UIAlertController(
                title: "Location Access Disabled",
                message: "To go to your current location, please open this app in settings under 'privacy' and set location access to 'Always'.",
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url as URL)
                }
            }
            alertController.addAction(openAction)
            
            
            self.present(alertController, animated: true, completion: nil)
        default: ()
            
        }

    }
    
    
    func update() { //'Current workaround for being unable to activate function from another viewcontroller'
        
        let selected: String = (UserDefaults.standard.object(forKey: "selector") as AnyObject) as! String
        let defaults = UserDefaults.standard
        defaults.set("-", forKey: "selector") //the char stored under the key 'selector' indicates whether the user has chosen (e)-waste, (b)attery, or (p)aint. Setting it to null here makes sure the function won't be continously called without reason
        
        if selected == "e" || selected == "b" || selected == "p" {
            removeOverlays() //Removes any previous MKPolyline on the map
            mapView.removeAnnotations(mapView.annotations) //Clears the annotations, ie if 'battery' is clicked, then this will clear the e-waste annotations
            
           
            var fileNames = ["EName", "ELat", "ELng", "EPhone", "EPost", "BName", "BLat", "BLng", "BPhone", "BPost", "PName", "PLat", "PLng", "PPhone", "PPost"] //Used as keys to access the local database of locations
            var initCounter = 0;
            while initCounter < 15 {
                if initCounter<5{ //This e-waste iteration will write the location's name, latitude, longitude, phone, and postal code into the Electronics[5][whatever] 2d array. It finds this information under the 'Database' folder to the left
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
            
            let sourceCoord = self.mapView.userLocation.coordinate
            let sourceLocation = CLLocation(latitude: sourceCoord.latitude, longitude: sourceCoord.longitude) //User's location
            
            
            if selected as! String == "e" { //Initializes all e-waste annotations
                var markCount = 0
                buttonClicked(sender: eButton) //highlights its button on the top
                while markCount < Electronics[1].count-1 { //1 is subtracted since the last entry line is null
                    let anno = MKPointAnnotation()
                    let myLocation = CLLocationCoordinate2DMake(Double(Electronics[1][markCount])!, Double(Electronics[2][markCount])!)
                    anno.coordinate = myLocation
                    anno.title = Electronics[0][markCount]
                    anno.subtitle = "Phone: " + Electronics[3][markCount] + "\n" + "Postal Code: " + Electronics[4][markCount]
                    self.mapView.addAnnotation(anno)
                    
                    markCount += 1
                }

                
            } else if selected as! String == "b" { //Initializes all battery annotations
                buttonClicked(sender: bButton)
                
                var markCount = 0
                while markCount < Battery[1].count-1 {
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
                while markCount < Paint[1].count-1 {
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

    
    
    
    func buttonClicked(sender:UIButton) { //Changes the aesthetic and colour scheme of the buttons
        //An alternative to set the button properties once initialized for each .normal and .selected states have been attempted, but has not worked.
        
        eButton.backgroundColor = UIColor.white
        bButton.backgroundColor = UIColor.white
        pButton.backgroundColor = UIColor.white
        
        eButton.setTitleColor(UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0), for: .normal)
        bButton.setTitleColor(UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0), for: .normal)
        pButton.setTitleColor(UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0), for: .normal)

        sender.backgroundColor = (UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0))
        sender.setTitleColor(UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0), for: .selected)
        sender.setTitleColor(UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0), for: .normal)
        
    }
    
    @IBAction func ewasteButton(_ sender: Any) { //Sets the selector to 'e' to indicates e-waste is now selected
        //This is currently a workaround, it only functions because we have a timer updating every 0.1 seconds that calls the update() function, and the update function promptly resets the selector to '-' and updates the annotations
        let defaults = UserDefaults.standard
        defaults.set("e", forKey: "selector")
        buttonClicked(sender: sender as! UIButton) //Changes aesthetics of the button

    }
    
    @IBAction func paintButton(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set("p", forKey: "selector")
        buttonClicked(sender: sender as! UIButton)
    }
    
    
    @IBAction func batteryButton(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set("b", forKey: "selector")
        buttonClicked(sender: sender as! UIButton)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { //Custom status bar colouring (top bar that shows battery, time etc)
        return .lightContent
        
    }

    
}




extension ViewControllerElec : CLLocationManagerDelegate { //A lot of this code is copied directly from Apple's Mapkit documentation
    
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
        //This code is only activated when the user's location has been detected.
        
        
        let locValue:CLLocationCoordinate2D = location.coordinate
        
        myUserLatitude = locValue.latitude //Since this only happens when user location is detected, this is a neat way to check if the user's location is active, otherwise myUserLatitude will be 1000.0 based on its initilization value
        myUserLongitude = locValue.longitude
        
        realFadeOut() //Fades out the loading button
        
        
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegion(center: location.coordinate, span: span) //Zooms into the user's position when his location is found
        
        
        mapView.setRegion(region, animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
}

extension ViewControllerElec: HandleMapSearch {
    
    func dropPinZoomIn(_ placemark: MKPlacemark){ //This zooms in to where the user set their location in the upper search bar
        //this code was copied, normally a pin is placed it is removed because it looks exactly like a recycle location pin
        // cache the pin
        selectedPin = placemark
        let annotation = MKPointAnnotation()
        //        annotation.coordinate = placemark.coordinate
        //        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.2, 0.2)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: false)
        mapView.setCenter(coordinate: mapView.centerCoordinate, zoomLevel: 10, animated: true)
        
    }
    
}


extension ViewControllerElec : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) { //This function makes sure that the user can't zoom out too much, or else the massive amount of pins will cause slow app performance.
        print("Zoom: \(mapView.getZoomLevel())")
        if mapView.getZoomLevel() < 8 {
            mapView.setCenter(coordinate: mapView.centerCoordinate, zoomLevel: 8, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer { //Customizes the overlay renderer for the polyline (outline of the route)

        
        if overlay.isKind(of: MKPolyline.self) {
            let polyline = overlay
            let polyLineRenderer = MKPolylineRenderer(overlay: polyline as! MKOverlay)
            // draw the track
            polyLineRenderer.lineDashPhase = 16     //This makes the route outline dashed rather than straight
            polyLineRenderer.lineDashPattern = [10, 7, 10, 7]
            polyLineRenderer.strokeColor = UIColor(red:0.23, green:0.57, blue:0.95, alpha:0.9)  //Tried to make the colour as similar as possible to that of Apple Maps's
            polyLineRenderer.lineWidth = 4.0
            
            
            return polyLineRenderer
            
            
        }
        
        
        return MKPolylineRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{ //This creates a custom MKAnnotation that displays labels and buttons
        
        guard !(annotation is MKUserLocation) else { return nil }
        
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        if #available(iOS 9.0, *) {
            pinView?.pinTintColor = UIColor.red
        } else {
            // Fallback on earlier versions
        }
        
        
        pinView?.canShowCallout = true      //Customized elements of the pin
        let smallSquare = CGSize(width: 50, height: 50)     //Size of button
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))       //Creates a button that when clicked, will show navigation to that pin
        button.setImage(UIImage(named: "car4.png"), for: UIControlState())
        button.setImage(UIImage(named: "car4.png"), for: .selected)
        button.setTitle("Go", for: .selected)
        button.setTitle("Go", for: .normal)
        button.setTitle("Go", for: .highlighted)
        button.titleEdgeInsets = UIEdgeInsets(top: 37,left: -119,bottom: 0,right: 0)        //For better aesthetics by making it properly align
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Raleway-Regular", size: 15)
        button.titleLabel?.text = "Go"
        button.imageEdgeInsets = UIEdgeInsetsMake(-5, 0, 5, 0)      //Aligns the button titleLabel and its image



        button.alpha = 0.9
        //
        //        [button, setImage,:[UIImage imageNamed:@"pressed.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
        button.accessibilityHint = String(Double(annotation.coordinate.latitude))   //Passes along the coordinate information so that it can be accesed by other functions through the sender tag
        button.accessibilityLabel = String(Double(annotation.coordinate.longitude))
        button.accessibilityValue = annotation.title!
        
        
        button.addTarget(self, action: #selector(ViewControllerElec.getDirections(sender:)), for:.touchUpInside)    //All the coordinate and title information is already encode within accessibility information. Hence the following function can function perfectly
        
        let subtitleView = UILabel()
        subtitleView.font = subtitleView.font.withSize(12)
        subtitleView.numberOfLines = 0
        subtitleView.text = annotation.subtitle!
        pinView!.detailCalloutAccessoryView = subtitleView
        
        
        pinView?.leftCalloutAccessoryView = button      //Organizing the callout by placing the button on the left
        
        
        
        
        
        return pinView
    }
    
    func getDirections(sender: UIButton){ //The navigational tools that function in-app
        
        switch CLLocationManager.authorizationStatus() {    //Reminds the user to enable location services
            
        case .restricted, .denied:
            let alertController = UIAlertController(
                title: "Location Access Disabled",
                message: "To go to your current location, please open this app in settings under 'privacy' and set location access to 'Always'.",
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url as URL)
                }
            }
            alertController.addAction(openAction)
            
            
            self.present(alertController, animated: true, completion: nil)
        default: ()
            
        }
        let userLat : Double? = UserDefaults.standard.object(forKey: "userLatitude") as! Double
        
        if myUserLatitude != 1000.0 {   //Ensures the user can't access the userlocation if it has not been determined yet
            
            //        guard let selectedPin = selectedPin else { return }
            //        let mapItem = MKMapItem(placemark: selectedPin)
            //        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            //        mapItem.openInMaps(launchOptions: launchOptions)
            
            
            let latitude: CLLocationDegrees = Double(sender.accessibilityHint!)!
            let longitude: CLLocationDegrees = Double(sender.accessibilityLabel!)!
            
            //        let regionDistance:CLLocationDistance = 10000
            //        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            //        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
            //        let options = [ MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            //        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            //        let mapItem = MKMapItem(placemark: placemark)
            //        mapItem.name = sender.accessibilityValue
            //        mapItem.openInMaps(launchOptions: options)
            let sourceLocation = mapView.userLocation.location?.coordinate
            let destinationLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            var routeCoordinates: [CLLocationCoordinate2D]
            routeCoordinates = [sourceLocation!, destinationLocation]
            
            let sourcePlacemark = MKPlacemark(coordinate: sourceLocation!, addressDictionary: nil)
            let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil) //Coordinates are not enough for the following, placemarks are needed
            
            let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
            let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
            
            let directionRequest = MKDirectionsRequest()
            directionRequest.source = sourceMapItem
            directionRequest.destination = destinationMapItem
            directionRequest.transportType = .automobile
            
            // Calculate the direction
            let directions = MKDirections(request: directionRequest) //Sends a request to Apple to get directions
            
            directions.calculate {
                (response, error) -> Void in
                
                guard let response = response else {
                    if let error = error {
                        print("Error: \(error)");
                    }
                    
                    return
                }
                
                self.removeOverlays2()      //Clears other overlays but without a fadeout animation
                
                let route = response.routes[0]
                var distance = Double(route.distance) //rounds distance to a tenth of a kilometer
                distance = distance/100.0
                distance.round()
                distance = distance/10.0
                UIView.animate(withDuration: 0.7, animations: { //Shows the overlay menu which includes two navigational buttons
                    self.distanceBackground.backgroundColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)
                    self.distanceBackground.alpha = 0.9
                    self.distanceLabel.text = String(Double(distance)) + " km"
                    self.cButton.alpha = 0.9
                    self.cButton.isEnabled = true
                    self.expandButton.alpha = 0.9
                    self.expandButton.isEnabled = true
                })
                
                
                self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads) //Adds an outline for the route (it is customized in the MKOverlayRenderer above)
                
                
                let rect = route.polyline.boundingMapRect
                overRect = rect
                let r = self.mapView.mapRectThatFits(rect, edgePadding: UIEdgeInsetsMake(100, 70, 100, 70)) //Zooms to show the route, but with some padding to look aesthetically better.
                self.mapView.setRegion(MKCoordinateRegionForMapRect(r), animated: true)
                
                
                
            }
        }
        
        
    }
    
    func removeOverlays() { //Removes the overlays :D
        
        UIView.animate(withDuration: 0.3, animations: {
            let myOverlays = self.mapView.self.overlays
            self.mapView.self.removeOverlays(myOverlays)
            
            self.mapView.overlays.forEach {
                if !($0 is MKUserLocation) {
                    self.mapView.remove($0)
                }
            }
            self.distanceLabel.text = ""
            self.distanceBackground.backgroundColor = UIColor.white
            self.distanceBackground.alpha = 0.1
            self.cButton.alpha = 0.0
            self.cButton.isEnabled = false //Also makes sure the extra navigation buttons can't be pressed anymore
            self.expandButton.alpha = 0.0
            self.expandButton.isEnabled = false
        })
    }
    func removeOverlays2() { //same as func removeOverlays() but without the animation
        let myOverlays = self.mapView.self.overlays
        self.mapView.self.removeOverlays(myOverlays)
        
        self.mapView.overlays.forEach {
            if !($0 is MKUserLocation) {
                self.mapView.remove($0)
            }
        }
        distanceLabel.text = ""
        distanceBackground.backgroundColor = UIColor.white
        distanceBackground.alpha = 0.1
        cButton.alpha = 0.0
        cButton.isEnabled = false
        expandButton.alpha = 0.0
        expandButton.isEnabled = false
    }
    
//     func showRoute(_ routes: [MKRoute], time: TimeInterval) {
//        for i in 0..<routes.count {
//            mapView.add(routes[i].polyline)
//        }
//    }
    
    
}


fileprivate let MERCATOR_OFFSET: Double = 268435456
fileprivate let MERCATOR_RADIUS: Double = 85445659.44705395

extension MKMapView {     //This function resizes the map when the zoom level is too large
    
    func getZoomLevel() -> Double {
        
        let reg = self.region
        let span = reg.span
        let centerCoordinate = reg.center
        
        // Get the left and right most lonitudes
        let leftLongitude = centerCoordinate.longitude - (span.longitudeDelta / 2)
        let rightLongitude = centerCoordinate.longitude + (span.longitudeDelta / 2)
        let mapSizeInPixels = self.bounds.size
        
        // Get the left and right side of the screen in fully zoomed-in pixels
        let leftPixel = self.longitudeToPixelSpaceX(longitude: leftLongitude)
        let rightPixel = self.longitudeToPixelSpaceX(longitude: rightLongitude)
        let pixelDelta = abs(rightPixel - leftPixel)
        
        let zoomScale = Double(mapSizeInPixels.width) / pixelDelta
        let zoomExponent = log2(zoomScale)
        let zoomLevel = zoomExponent + 20
        
        return zoomLevel
    }
    
    func setCenter(coordinate: CLLocationCoordinate2D, zoomLevel: Int, animated: Bool) {
        
        let zoom = min(zoomLevel, 28)
        
        let span = self.coordinateSpan(centerCoordinate: coordinate, zoomLevel: zoom)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        self.setRegion(region, animated: true)
    }
    
    // MARK: - Private func
    
    private func coordinateSpan(centerCoordinate: CLLocationCoordinate2D, zoomLevel: Int) -> MKCoordinateSpan {
        
        // Convert center coordiate to pixel space
        let centerPixelX = self.longitudeToPixelSpaceX(longitude: centerCoordinate.longitude)
        let centerPixelY = self.latitudeToPixelSpaceY(latitude: centerCoordinate.latitude)
        
        // Determine the scale value from the zoom level
        let zoomExponent = 20 - zoomLevel
        let zoomScale = NSDecimalNumber(decimal: pow(2, zoomExponent)).doubleValue
        
        // Scale the map’s size in pixel space
        let mapSizeInPixels = self.bounds.size
        let scaledMapWidth = Double(mapSizeInPixels.width) * zoomScale
        let scaledMapHeight = Double(mapSizeInPixels.height) * zoomScale
        
        // Figure out the position of the top-left pixel
        let topLeftPixelX = centerPixelX - (scaledMapWidth / 2)
        let topLeftPixelY = centerPixelY - (scaledMapHeight / 2)
        
        // Find delta between left and right longitudes
        let minLng: CLLocationDegrees = self.pixelSpaceXToLongitude(pixelX: topLeftPixelX)
        let maxLng: CLLocationDegrees = self.pixelSpaceXToLongitude(pixelX: topLeftPixelX + scaledMapWidth)
        let longitudeDelta: CLLocationDegrees = maxLng - minLng
        
        // Find delta between top and bottom latitudes
        let minLat: CLLocationDegrees = self.pixelSpaceYToLatitude(pixelY: topLeftPixelY)
        let maxLat: CLLocationDegrees = self.pixelSpaceYToLatitude(pixelY: topLeftPixelY + scaledMapHeight)
        let latitudeDelta: CLLocationDegrees = -1 * (maxLat - minLat)
        
        return MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
    }
    
    private func longitudeToPixelSpaceX(longitude: Double) -> Double {
        return round(MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * M_PI / 180.0)
    }
    
    private func latitudeToPixelSpaceY(latitude: Double) -> Double {
        if latitude == 90.0 {
            return 0
        } else if latitude == -90.0 {
            return MERCATOR_OFFSET * 2
        } else {
            return round(MERCATOR_OFFSET - MERCATOR_RADIUS * Double(logf((1 + sinf(Float(latitude * M_PI) / 180.0)) / (1 - sinf(Float(latitude * M_PI) / 180.0))) / 2.0))
        }
    }
    
    private func pixelSpaceXToLongitude(pixelX: Double) -> Double {
        return ((round(pixelX) - MERCATOR_OFFSET) / MERCATOR_RADIUS) * 180.0 / M_PI
    }
    
    
    private func pixelSpaceYToLatitude(pixelY: Double) -> Double {
        return (M_PI / 2.0 - 2.0 * atan(exp((round(pixelY) - MERCATOR_OFFSET) / MERCATOR_RADIUS))) * 180.0 / M_PI
    }
}



