//
//  PushViewController.swift
//  Cruuze
//
//  Created by Landon Haugh on 5/18/19.
//  Copyright © 2019 Landon Haugh. All rights reserved.
//

import UIKit
import CoreLocation

class PushViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        print("Location data streaming...")
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Updating location data...")
        let speed = locationManager.location?.speed
        let latitude = locationManager.location?.coordinate.latitude
        let longitude = locationManager.location?.coordinate.longitude
        updateLocationInfo(speed: speed!, latitude: latitude!, longitude: longitude!)
    }
    
    @IBOutlet weak var speedText: UILabel!
    func updateLocationInfo(speed: CLLocationSpeed, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        print("updateLocationInfo triggered!")
        let speedToMPH = (speed * 2.23694)
        let s = String(speedToMPH)
        let lat = String(latitude)
        let lon = String(longitude)
        let ref = appDelegate.ref
        ref?.child("location_data").child("speed").setValue(["speed" : s])
        ref?.child("location_data").child("latitude").setValue(["latitude": lat])
        ref?.child("location_data").child("longitude").setValue(["longitude": lon])
        speedText.text = s
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        print("Location data stream stopping...")
        locationManager.stopUpdatingLocation()
        self.dismiss(animated:true, completion: nil)
    }
    
}
