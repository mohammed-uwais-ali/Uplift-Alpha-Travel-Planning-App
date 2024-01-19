//
//  ThirdViewController.swift
//  MapDemo
//
//  Created by Sam Pan on 11/10/23.
//  Copyright © 2023 Todd Sproull. All rights reserved.
//
import MapKit
import FirebaseCore
import FirebaseFirestore
import UIKit
class LocationViewController: UIViewController, AddReviewDelegate, UITableViewDelegate, UITableViewDataSource {
    var reviewsUser: [String] = []
    var reviewsBody: [String] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewsUser.count //placeholder #. Connect with DB
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reviewCell")
        cell.textLabel!.text = "\(reviewsUser[indexPath.row])"
        cell.detailTextLabel!.text = "\(reviewsBody[indexPath.row])"
        cell.detailTextLabel!.numberOfLines = 0
        return cell
    }
    
    
    let locationName = UILabel()
    let addButton = UIButton(type: .system)
    let closeButton = UIButton(type: .system)
    let mobilityView = UIView()
    let sensoryView = UIView()
    let neurologicalView = UIView()
    let websiteView = UIView()
    let directionView = UIView()
    let phoneView = UIView()
    let reviewDisplayView = UIView()
    var mobilityButton: StatisticalButton!
    var sensoryButton: StatisticalButton!
    var neurologicalButton: StatisticalButton!
    var websiteURL: String = ""
    var phoneNumber: String = ""
    var db: Firestore!
    var location: MKMapItem!
    var tableView: UITableView!
    var theAnnotations: [MKAnnotation]!
    var theMap: MKMapView!
    
    func didSubmitReview(withAverages averages: (Double, Double, Double)) {
        updateLocationName(location)
    }
    
    weak var delegate: LocationViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        closeButton.isUserInteractionEnabled = true
        addButton.isUserInteractionEnabled = true
        setTop()
        setUpStatistics(averageN: 0.0, averageM: 0.0, averageS: 0.0)
        db = Firestore.firestore()
       
    }
    
    func setTop() {
        locationName.numberOfLines = 0 // Set number of lines to 0 to allow multiple lines
        locationName.lineBreakMode = .byWordWrapping
        locationName.text = ""
        locationName.font = UIFont.systemFont(ofSize: 20)
        locationName.translatesAutoresizingMaskIntoConstraints = false
        locationName.accessibilityLabel = "This is the name of your selected location"
        view.addSubview(locationName)
        locationName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -10).isActive = true
        locationName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        locationName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant:-30).isActive = true
        
        let maxWidth: CGFloat = 200 // Change this value according to your layout
        locationName.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth).isActive = true
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(named: "X"), for: .normal)
        closeButton.contentHorizontalAlignment = .center
        closeButton.contentVerticalAlignment = .center
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        closeButton.accessibilityLabel = "Close the more detailed description and return to the main map."
        view.addSubview(closeButton)
        closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant:-10).isActive = true
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -10).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 35).isActive = true


        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.backgroundColor =  UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        addButton.accessibilityLabel = "Press to create a review."
        view.addSubview(addButton)
        addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -10).isActive = true
        addButton.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -10).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
    }
    func updateLocationName(_ mapItem: MKMapItem) {
        print(mapItem)
        location = mapItem
        locationName.text = mapItem.name!
        print(mapItem.placemark.coordinate.latitude)
        print(mapItem.placemark.coordinate.longitude)
        let reviews = db.collection("reviews")
        reviews
            .whereField("latitude", isEqualTo: mapItem.placemark.coordinate.latitude)
            .whereField("longitude", isEqualTo: mapItem.placemark.coordinate.longitude)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                  print("Error getting documents: \(err)")
                } else {
                    var totalMobility = 0.0
                    var totalNeurological = 0.0
                    var totalSensory = 0.0
                  for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                      //got data, compute average
                      totalNeurological += document.data()["neurological"] as! Double
                      totalSensory += document.data()["sensory"] as! Double
                      totalMobility += document.data()["mobility"] as! Double
                      if let reviewBody = document.data()["review"] {
                          self.reviewsBody.append(reviewBody as! String)
                          self.reviewsUser.append(document.data()["username"] as! String)
                      }
                  }
                    self.tableView.reloadData()
                    let averageN = totalNeurological / Double(querySnapshot!.documents.count)
                    let averageM = totalMobility / Double(querySnapshot!.documents.count)
                    let averageS = totalSensory / Double(querySnapshot!.documents.count)
                    if averageN.isNaN {
                        self.mobilityButton.setMainText("No Data")
                        self.sensoryButton.setMainText("No Data")
                        self.neurologicalButton.setMainText("No Data")
                    } else {
                        self.mobilityButton.setMainText("\(averageM.rounded())")
                        self.sensoryButton.setMainText("\(averageS.rounded())")
                        self.neurologicalButton.setMainText("\(averageN.rounded())")
                    }
                    self.mobilityView.backgroundColor = self.getColor(for: averageM)
                    self.sensoryView.backgroundColor = self.getColor(for: averageS)
                    self.neurologicalView.backgroundColor = self.getColor(for: averageN)
                    self.mobilityView.accessibilityLabel = "This describes the mobility score of the location. Click inside for more info."
                    self.sensoryView.accessibilityLabel = "This describes the sensory score of the location. Click inside for more info."
                    self.neurologicalView.accessibilityLabel = "This describes the neurological score of the location. Click inside for more info."
                    
                }
              }
    }
    func setWebsiteURl(_ url: String) {
        websiteURL = url
    }
    func setPhoneNum(_ num: String) {
        phoneNumber = num
    }
    
    func setUpStatistics(averageN: Double, averageM: Double, averageS: Double) {
        mobilityView.translatesAutoresizingMaskIntoConstraints = false
        mobilityView.layer.cornerRadius = 10
        mobilityView.layer.borderWidth = 1
        mobilityView.layer.borderColor = UIColor.black.cgColor
        view.addSubview(mobilityView)
        mobilityView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        mobilityView.topAnchor.constraint(equalTo: locationName.bottomAnchor,constant:20).isActive = true
        mobilityView.widthAnchor.constraint(equalToConstant: 110).isActive = true
        mobilityView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        mobilityView.backgroundColor = UIColor(red: 50/255, green: 167/255, blue: 82/255, alpha: 1)
        
        
        mobilityButton = StatisticalButton()
        mobilityButton.setMainText("\(averageM.rounded())")
        mobilityButton.setAdditionalText("Mobility")
        mobilityButton.accessibilityLabel = "This location's Mobility Score."
        mobilityButton.translatesAutoresizingMaskIntoConstraints = false
        mobilityView.addSubview(mobilityButton)
        mobilityButton.centerXAnchor.constraint(equalTo: mobilityView.centerXAnchor).isActive = true
        mobilityButton.centerYAnchor.constraint(equalTo: mobilityView.centerYAnchor,constant: -10).isActive = true
        
        // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 2.3 Multiple for 13PM
        sensoryView.translatesAutoresizingMaskIntoConstraints = false
        sensoryView.layer.cornerRadius = 10
        sensoryView.layer.borderWidth = 1
        sensoryView.layer.borderColor = UIColor.black.cgColor
        view.addSubview(sensoryView)
        sensoryView.leadingAnchor.constraint(equalTo: mobilityView.trailingAnchor, constant: 10).isActive = true
        sensoryView.topAnchor.constraint(equalTo: locationName.bottomAnchor,constant:20).isActive = true
        sensoryView.widthAnchor.constraint(equalToConstant: 110).isActive = true
        sensoryView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        sensoryView.backgroundColor = UIColor(red: 244/255, green: 96/255, blue: 88/255, alpha: 1)
        
        sensoryButton = StatisticalButton()
        sensoryButton.setMainText("\(averageS.rounded())")
        sensoryButton.setAdditionalText("Sensory")
        sensoryButton.accessibilityLabel = "This location's Sensory Score."
        sensoryButton.translatesAutoresizingMaskIntoConstraints = false
        sensoryView.addSubview(sensoryButton)
        sensoryButton.centerXAnchor.constraint(equalTo: sensoryView.centerXAnchor).isActive = true
        sensoryButton.centerYAnchor.constraint(equalTo: sensoryView.centerYAnchor,constant: -10).isActive = true
        
        
        neurologicalView.translatesAutoresizingMaskIntoConstraints = false
        neurologicalView.layer.cornerRadius = 10
        neurologicalView.layer.borderWidth = 1
        neurologicalView.layer.borderColor = UIColor.black.cgColor
        view.addSubview(neurologicalView)
        neurologicalView.leadingAnchor.constraint(equalTo: sensoryView.trailingAnchor, constant: 10).isActive = true
        neurologicalView.topAnchor.constraint(equalTo: locationName.bottomAnchor,constant:20).isActive = true
        neurologicalView.widthAnchor.constraint(equalToConstant: 110).isActive = true
        neurologicalView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        neurologicalView.backgroundColor = UIColor(red: 241/255, green: 153/255, blue: 5/255, alpha: 1)
        
        neurologicalButton = StatisticalButton()
        neurologicalButton.setMainText("\(averageN.rounded())")
        neurologicalButton.setAdditionalText("Neurological")
        neurologicalButton.translatesAutoresizingMaskIntoConstraints = false
        neurologicalButton.accessibilityLabel = "This location's Neurological Score."
        neurologicalView.addSubview(neurologicalButton)
        neurologicalButton.centerXAnchor.constraint(equalTo: neurologicalView.centerXAnchor).isActive = true
        neurologicalButton.centerYAnchor.constraint(equalTo: neurologicalView.centerYAnchor,constant: -10).isActive = true
        
        websiteView.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        websiteView.translatesAutoresizingMaskIntoConstraints = false
        websiteView.layer.cornerRadius = 10
        websiteView.accessibilityLabel = "Look here to access this location's website. Click the button inside to go to the page."
        view.addSubview(websiteView)
        websiteView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        websiteView.topAnchor.constraint(equalTo: mobilityView.bottomAnchor, constant:20).isActive = true
        websiteView.widthAnchor.constraint(equalToConstant: 97).isActive = true
        websiteView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        // 1.75 for 13PM
        let websiteButton = ImageButton()
        websiteButton.setMainImage(UIImage(named: "website")!)
        websiteButton.setAdditionalText("Website")
        websiteButton.translatesAutoresizingMaskIntoConstraints = false
        websiteButton.accessibilityLabel = "Click here to access the location's website."
        websiteView.addSubview(websiteButton)
        websiteButton.centerXAnchor.constraint(equalTo: websiteView.centerXAnchor).isActive = true
        websiteButton.centerYAnchor.constraint(equalTo: websiteView.centerYAnchor,constant: -10).isActive = true
        websiteButton.addTarget(self, action: #selector(websiteButtonTap), for: .touchUpInside)
        directionView.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        directionView.translatesAutoresizingMaskIntoConstraints = false
        directionView.layer.cornerRadius = 10
        directionView.accessibilityLabel = "Look here for direction information about this location. Click the button inside to automatically launch directions."
        view.addSubview(directionView)
        directionView.leadingAnchor.constraint(equalTo: websiteView.trailingAnchor, constant: 18).isActive = true
        directionView.topAnchor.constraint(equalTo: mobilityView.bottomAnchor, constant:20).isActive = true
        directionView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        directionView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        let directionButton = ImageButton()
        directionButton.setMainImage(UIImage(named: "directions")!)
        directionButton.setAdditionalText("Directions")
        directionButton.translatesAutoresizingMaskIntoConstraints = false
        directionButton.accessibilityLabel = "Click here to launch directions in Apple Maps."
        directionView.addSubview(directionButton)
        directionButton.centerXAnchor.constraint(equalTo: directionView.centerXAnchor).isActive = true
        directionButton.centerYAnchor.constraint(equalTo: directionView.centerYAnchor,constant: -10).isActive = true
        directionButton.addTarget(self, action: #selector(directionButtonTap), for: .touchUpInside)
        
        phoneView.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        phoneView.translatesAutoresizingMaskIntoConstraints = false
        phoneView.layer.cornerRadius = 10
        phoneView.accessibilityLabel = "Look here for contact information about this location. Click the button inside to automatically call this location's registered phone number."
        view.addSubview(phoneView)
        phoneView.leadingAnchor.constraint(equalTo: directionView.trailingAnchor, constant: 18).isActive = true
        phoneView.topAnchor.constraint(equalTo: mobilityView.bottomAnchor, constant:20).isActive = true
        phoneView.widthAnchor.constraint(equalToConstant: 97).isActive = true
        phoneView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        let phoneButton = ImageButton()
        phoneButton.setMainImage(UIImage(named: "phone")!)
        phoneButton.setAdditionalText("Phone")
        phoneButton.translatesAutoresizingMaskIntoConstraints = false
        phoneButton.accessibilityLabel = "Click here to automatically call this location."
        phoneView.addSubview(phoneButton)
        phoneButton.centerXAnchor.constraint(equalTo: phoneView.centerXAnchor).isActive = true
        phoneButton.centerYAnchor.constraint(equalTo: phoneView.centerYAnchor,constant: -10).isActive = true
        
        tableView = UITableView(frame: CGRect(x: websiteView.center.x, y: websiteView.center.y - 40.0, width: 350, height: 60))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reviewCell")
        tableView.layer.cornerRadius = 10
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        tableView.topAnchor.constraint(equalTo: directionView.bottomAnchor, constant:20).isActive = true
        tableView.widthAnchor.constraint(equalToConstant: 372).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        tableView.accessibilityLabel = "Here is a list of all the previous reviews of this location."
        phoneButton.addTarget(self, action: #selector(phoneButtonTap), for: .touchUpInside)
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 100)
                
        let image = UIImage(named: "star")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "Click this button to add this location to your favorites."
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addButton.layer.cornerRadius = addButton.frame.size.width/2
        addButton.clipsToBounds = true

        closeButton.layer.cornerRadius = addButton.frame.size.width/2
        closeButton.clipsToBounds = true
    }
    
    @objc func websiteButtonTap() {
        let websiteVC = WebsiteViewController()
        websiteVC.getURL(websiteURL)
        self.present(websiteVC, animated: true, completion: nil)
    }
    
    @objc func phoneButtonTap() {
        print("got here")
        
//        let destination = CLLocationCoordinate2D(latitude: location.placemark.coordinate.latitude, longitude: location.placemark.coordinate.longitude)
//        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: destination))
//        let phoneNumber = mapItem.phoneNumber
//        print(phoneNumber)
        print(phoneNumber)
        if let phoneURL = URL(string: "tel://\(removeErrCharacters(phoneNumber))") {
            if UIApplication.shared.canOpenURL(phoneURL) {
                print(phoneURL)
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            } else {
                print("cannot make phone call")
            }
        }
    }

    @objc func addButtonTapped() {
        let reviewVC = AddReviewViewController(latitude: location.placemark.coordinate.latitude, longitude: location.placemark.coordinate.longitude)
        reviewVC.delegate = self
        self.present(reviewVC, animated: true, completion: nil)
    }
    
    func removeErrCharacters(_ rawPhoneNumber: String) -> String {
        let allowedCharacters = CharacterSet(charactersIn: "+0123456789")
        let filteredCharacters = rawPhoneNumber.components(separatedBy: allowedCharacters.inverted)
        let newNumber = filteredCharacters.joined()
        return newNumber
    }
    
    @objc func directionButtonTap() {
        // when button is clicked go to Apple Maps application for turn-by-turn directions from current location to selected location
        print("directions button clicked")
        let destination = CLLocationCoordinate2D(latitude: location.placemark.coordinate.latitude, longitude: location.placemark.coordinate.longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        mapItem.name = mapItem.name!
        // get directions using the user's perferred mode of travel (ex. walking, driving, public transit)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault]
        // open in Apple Maps and for turn-by-turn directions to destination
        mapItem.openInMaps(launchOptions: launchOptions)
    }


    
    @objc func closeButtonTapped() {
        dismissViewController()
    }
    @objc func showMobilityStats() {
        print("mymobility")
    }
    func dismissViewController() {
        theMap.removeAnnotations(theAnnotations)
        self.dismiss(animated: true) {
            self.delegate?.locationViewControllerDidClose()
        }
    }
    
    func storeAnnotations(_ mapView: MKMapView) {
        theAnnotations = mapView.annotations
        theMap = mapView
    }
    
    func getColor(for value: Double) -> UIColor {
          let clampedValue = min(max(value, 0), 100) // Clamp the value between 0 and 100
              var red: CGFloat = 0.0
              var green: CGFloat = 0.0
              
              if clampedValue >= 75 {
                  let ratio = (181 - 0) / (75 - 100)
                  red = 181 + (value - 75) * Double(ratio)
                  green = 181.0
              } else if clampedValue >= 50 {
                  red = 181.0
                  let ratio = (value - 50) / (75 - 50)
                  green = round(ratio * (181))
              } else {
                  red = 181.0
                  let ratio = (value) / 50
                  green =  round(ratio * 90)
              }
          return UIColor(red: red/255.0, green: green/255.0, blue: 0.0, alpha: 0.5)
      }
    
    @objc func buttonAction() {
        var favoritedLocations = UserDefaults.standard.stringArray(forKey: "favoritedLocations") ?? []
        let locationName = locationName.text
        if !favoritedLocations.contains(locationName!) {
            favoritedLocations.append(locationName!)
            UserDefaults.standard.set(favoritedLocations, forKey: "favoritedLocations")
        }
    }
  
}
protocol LocationViewControllerDelegate: AnyObject {
    func locationViewControllerDidClose()
}



