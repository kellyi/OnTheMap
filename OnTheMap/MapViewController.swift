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

    let studentLocations = StudentLocations()
    var students: [Student] = []
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        populateMapView()
    }
    
    func populateMapView() {
        studentLocations.getStudentLocationsUsingCompletionHandler() { (result) in
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
    
    func annotateMapWithStudentLocations() {
        for student in students {
            createAnnotationFromSingleLocation(student)
        }
    }
    
    func createAnnotationFromSingleLocation(student: Student) {
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
}
