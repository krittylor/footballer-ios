//
//  MapController.swift
//  Football
//
//  Created by Admin User on 3/7/17.
//  Copyright © 2017 prosunshining. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import GooglePlaces
class MapPlayerController: UIViewController {
    public var longitude: CLLocationDegrees = 51.5075046
    public var latitude: CLLocationDegrees = -0.1276519
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var mapContainer: UIView!
    override func loadView() {

        super.loadView()
        let camera = GMSCameraPosition.camera(withLatitude: self.latitude, longitude: self.longitude, zoom: 12)
        let frame = CGRect(x: 0, y: 60, width: self.view.frame.size.width, height: self.view.frame.size.height - 60)
        let mapView = GMSMapView.map(withFrame: frame, camera: camera)
        //        self.view.addSubview(mapView)
        self.view = mapView
        mapView.isMyLocationEnabled = true
        mapView.accessibilityElementsHidden = false
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



