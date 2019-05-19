//
//  ReceiveViewController.swift
//  Cruuze
//
//  Created by Landon Haugh on 5/18/19.
//  Copyright © 2019 Landon Haugh. All rights reserved.
//

import UIKit
import MapKit

class ReceiveViewController: UIViewController, MKMapViewDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var resultText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.showsUserLocation = true
        let ref = appDelegate.ref
        ref?.observe(.value, with: { snapshot in
            let sval = snapshot.childSnapshot(forPath: "location_data").childSnapshot(forPath: "speed").value as? NSDictionary
            let lonval = snapshot.childSnapshot(forPath: "location_data").childSnapshot(forPath: "longitude").value as? NSDictionary
            let latval = snapshot.childSnapshot(forPath: "location_data").childSnapshot(forPath: "latitude").value as? NSDictionary
            let speed = sval?["speed"] as? String ?? ""
            let lon = lonval?["longitude"] as? String ?? ""
            let lat = latval?["latitude"] as? String ?? ""
            print("Latitude: \(lat)")
            print("Longitude: \(lon)")
            self.centerMapOnLocation(latitude: Double(lat) as! CLLocationDegrees, longitude: Double(lon) as! CLLocationDegrees)
            self.resultText.text = speed
        })
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        self.dismiss(animated:true, completion: nil)
    }
    
    func centerMapOnLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        DispatchQueue.main.async {
            self.mapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.mapView.addAnnotation(annotation)
        }
    }
}
