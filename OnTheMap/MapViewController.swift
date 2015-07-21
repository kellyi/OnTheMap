//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Kelly Innes on 7/1/15.
//  Copyright (c) 2015 Kelly Innes. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    var students: [Student] = []
    
    @IBOutlet weak var mapView: MKMapView!

    // MARK: - Setup View
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        populateMapView()
    }
    
    func populateMapView() {
        // retrieve results from Parse API
        ParseClient.sharedInstance().getStudentLocationsUsingCompletionHandler() { (result) in
            switch result {
            case .Success(let students):
                self.students = students
                self.annotateMapWithStudentLocations()
            case .Failure(let error):
                self.students = []
                println(error)
            }
        }
    }
    
    // MARK: - Setup and Add Map Annotations
    
    func annotateMapWithStudentLocations() {
        // loop through array to create an annotation for each
        for student in students {
            createAnnotationFromSingleLocation(student)
        }
    }
    
    func createAnnotationFromSingleLocation(student: Student) {
        // set annotation popup appearance
        let studentLatitude = CLLocationDegrees(student.latutide)
        let studentLongitude = CLLocationDegrees(student.longitude)
        let studentName = "\(student.firstName) \(student.lastName)"
        let studentURL = "\(student.mediaURL)"
        let annotationLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: studentLatitude, longitude: studentLongitude)
        var annotation = MKPointAnnotation()
        annotation.coordinate = annotationLocation
        annotation.title = studentName
        annotation.subtitle = studentURL
        mapView.addAnnotation(annotation)
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        // add calloutAccessoryControl & action when tapped
        if control == view.rightCalloutAccessoryView{
            UIApplication.sharedApplication().openURL(NSURL(string: view.annotation.subtitle!)!)
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        // set pin and calloutAccessoryView appearance
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
        }
        var button = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
        pinView?.rightCalloutAccessoryView = button
        return pinView
    }
}
