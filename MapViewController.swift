//
//  MapViewController.swift
//  Uplift
//
//  Created by George Mitrev on 11/11/23.
// resources: https://developer.apple.com/videos/play/wwdc2022/10035/?time=1034

import UIKit
import MapKit
import CoreLocation
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, LocationViewControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var db: Firestore!
    var didZoomToRegion = false
    @IBOutlet weak var preview: UIView!
    var lookAroundViewController : MKLookAroundViewController?
    @IBOutlet weak var searchBar: UISearchBar!
    var locationViewController: LocationViewController?
    var mapLocation:MKMapItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        mapView.delegate = self
        mapView.mapType = .mutedStandard
        mapView.preferredConfiguration.elevationStyle = .realistic
        mapView.selectableMapFeatures = [.pointsOfInterest]
        searchBar.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        configureSheet()
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonTapped))
               navigationItem.rightBarButtonItem = logoutButton
    }
    @objc func logoutButtonTapped() {
            // Perform any logout logic if needed

                
        self.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // function for presenting Look Around View Controller
        if segue.identifier == "presentLookAroundEmbedded" {
            if let lookAroundViewController = segue.destination as? MKLookAroundViewController {
                self.lookAroundViewController = lookAroundViewController
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // use location information to update view on screen (zoom to location)
        guard let location = locations.last else {return}
        print(location)
        if !didZoomToRegion {
            let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(viewRegion, animated: true)
            didZoomToRegion = true
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // This tutorial was helpful here: https://www.youtube.com/watch?v=GYzNsVFyDrU
        
        mapView.isUserInteractionEnabled = true
        
        let actInd = UIActivityIndicatorView()
        actInd.style = UIActivityIndicatorView.Style.medium
        actInd.center = self.view.center
        actInd .hidesWhenStopped = true
        actInd.startAnimating()
        
        searchBar.resignFirstResponder()
        //dismiss(animated: true, completion: nil)
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { [self] response, error in
            if response == nil {
                print("ERROR")
            }
            else {
                // print(response?.mapItems.first)
                
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                
                let lat = response?.boundingRegion.center.latitude
                let long = response?.boundingRegion.center.longitude
                
                let newAnnotation = MKPointAnnotation()
                newAnnotation.title = response?.mapItems.first?.name!
                newAnnotation.coordinate = CLLocationCoordinate2DMake(lat!, long!)
                self.mapView.addAnnotation(newAnnotation)
                
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat!, long!)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
                
                do {
                    // Fetch the map item
                    let featureItem = response!.mapItems.first
                    // print(featureItem)
                    mapLocation = featureItem
                    // get look around scene option if available
                    self.configureLookAroundScene(featureItem!)
                    if let mapLocation = mapLocation {
                        if let presentedVC = presentedViewController {
                            presentedVC.dismiss(animated: true) {
                                self.showLocationSheet {
                                    self.locationViewController?.storeAnnotations(mapView)
                                    if mapLocation.name != nil {
                                        self.locationViewController?.updateLocationName(mapLocation)
                                    }
                                    if let urlString = mapLocation.url?.absoluteString {
                                        self.locationViewController?.setWebsiteURl(urlString)
                                    }
                                    if let itemPhoneNumber = mapLocation.phoneNumber {
                                        self.locationViewController?.setPhoneNum(itemPhoneNumber)
                                    }
                                }
                            }
                        } else {
                            self.showLocationSheet {
                                self.locationViewController?.storeAnnotations(mapView)
                                if mapLocation.name != nil {
                                    self.locationViewController?.updateLocationName(self.mapLocation!)
                                }
                                if let urlString = mapLocation.url?.absoluteString {
                                    self.locationViewController?.setWebsiteURl(urlString)
                                }
                                if let itemPhoneNumber = mapLocation.phoneNumber {
                                    self.locationViewController?.setPhoneNum(itemPhoneNumber)
                                }
                            }
                        }
                    }

                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        // Ensure the annotation is of the correct type
        guard let featureAnnotation = annotation as? MKMapFeatureAnnotation else { return }

        // Create an instance of MKMapItemRequest
        let featureRequest = MKMapItemRequest(mapFeatureAnnotation: featureAnnotation)

        // Use async/await to fetch the map item details
        Task {
            do {
                // Fetch the map item
                let featureItem = try await featureRequest.mapItem
                print(featureItem)
                mapLocation = featureItem
                // get look around scene option if available
                self.configureLookAroundScene(featureItem)
                if let mapLocation = mapLocation {
                    if let presentedVC = presentedViewController {
                        presentedVC.dismiss(animated: true) {
                            self.showLocationSheet {
                                self.locationViewController?.storeAnnotations(mapView)
                                if mapLocation.name != nil {
                                    self.locationViewController?.updateLocationName(mapLocation)
                                }
                                if let urlString = mapLocation.url?.absoluteString {
                                    self.locationViewController?.setWebsiteURl(urlString)
                                }
                                if let itemPhoneNumber = mapLocation.phoneNumber {
                                    self.locationViewController?.setPhoneNum(itemPhoneNumber)
                                }
                            }
                        }
                    } else {
                        self.showLocationSheet {
                            self.locationViewController?.storeAnnotations(mapView)
                            if mapLocation.name != nil {
                                self.locationViewController?.updateLocationName(self.mapLocation!)
                            }
                            if let urlString = mapLocation.url?.absoluteString {
                                self.locationViewController?.setWebsiteURl(urlString)
                            }
                            if let itemPhoneNumber = mapLocation.phoneNumber {
                                self.locationViewController?.setPhoneNum(itemPhoneNumber)
                            }
                        }
                    }
                } 

            } catch {
                // Handle errors that occurred during the asynchronous operation
                print("Error fetching map item: \(error)")
            }
        }
    }
    
    func configureLookAroundScene(_ item: MKMapItem) {
        guard let lookAroundViewController = self.lookAroundViewController else {return}
        let lookAroundRequest = MKLookAroundSceneRequest(mapItem: item)
        
        Task {
            // want to show look around preview if it is available
            do {
                // issue look around scene request
                guard let lookAroundScene = try await lookAroundRequest.scene else {
                    DispatchQueue.main.async {
                        self.preview.isHidden = true
                    }
                    return
                }
                DispatchQueue.main.async {
                    lookAroundViewController.scene = lookAroundScene
                    // show preview
                    self.preview.isHidden = false
                }
            }
        }
    }
    
    func configureSheet() {
        let vc = MainSheetViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.isModalInPresentation = true
        
        if let sheet = navVC.sheetPresentationController {
            sheet.preferredCornerRadius = 10
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.detents = [.custom(resolver: { context in 0.4  * context.maximumDetentValue}),
                             .custom(resolver: { context in 0.06 * context.maximumDetentValue}), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.selectedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = true
            sheet.largestUndimmedDetentIdentifier = .large
        }
//        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        navigationController?.present(navVC, animated:true)
        }
    func showLocationSheet(completion: (() -> Void)? = nil) {
        let vc = LocationViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .pageSheet
                
        if let sheet = navVC.sheetPresentationController {
            sheet.preferredCornerRadius = 10
            sheet.detents = [.custom(resolver: { context in
                0.45  * context.maximumDetentValue}),
                .custom(resolver: { context in
                    0.6  * context.maximumDetentValue}),
                .custom(resolver: { context in
                    0.06 * context.maximumDetentValue })]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.selectedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = true
            sheet.largestUndimmedDetentIdentifier = .large
        }
        locationViewController = vc
        locationViewController?.delegate = self
        navigationController?.present(navVC, animated: true) {
                completion?()
        }
    }
    func locationViewControllerDidClose() {
        configureSheet()
    }
}
