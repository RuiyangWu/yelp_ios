//
//  MapViewController.swift
//  Yelp
//
//  Created by ruiyang_wu on 8/11/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager : CLLocationManager!

    var businesses: [Business]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // set the region to display, this also sets a correct zoom level
        // set starting center location in San Francisco
        let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
        goToLocation(centerLocation)

        // Use location manager to request user's current location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()

        // Annotate all locations
        for business in businesses {
          addAnnotationAtCoordinate(business.coordinate!, title: business.name!)
        }
    }

    private func goToLocation(location: CLLocation) {
      let span = MKCoordinateSpanMake(0.1, 0.1)
      let region = MKCoordinateRegionMake(location.coordinate, span)
      mapView.setRegion(region, animated: false)
    }

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
      if status == CLAuthorizationStatus.AuthorizedWhenInUse {
        locationManager.startUpdatingLocation()
      }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      if let location = locations.first {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
      }
    }

    // Simple annotation which supports a title
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D, title: String) {
      let annotation = MKPointAnnotation()
      annotation.coordinate = coordinate
      annotation.title = title
      mapView.addAnnotation(annotation)
    }
  
    // Custom annotation with custom image
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
      print("good TTTT")
      let identifier = "customAnnotationView"

      // custom image annotation
      var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
      if (annotationView == nil) {
        annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      }
      else {
        annotationView!.annotation = annotation
      }
      annotationView!.image = UIImage(named: "yelpicon")

      return annotationView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  @IBAction func onBack(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
