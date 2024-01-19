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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15 //placeholder #. Connect with DB
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reviewCell")
        cell.textLabel!.text = "Username: "
        cell.detailTextLabel!.text = "Placeholder review"
        cell.backgroundColor = .blue
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
    var db: Firestore!
    var location: MKMapItem!
    var tableView: UITableView!
    func didSubmitReview(withAverages averages: (Double, Double, Double)) {
            // Update your UI with the new averages
            updateLocationName(location)
        
        }
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
        locationName.text = ""
        locationName.font = UIFont.systemFont(ofSize: 30)
        locationName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locationName)
        locationName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -10).isActive = true
        locationName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(named: "X"), for: .normal)
        closeButton.contentHorizontalAlignment = .center
        closeButton.contentVerticalAlignment = .center
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
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
        view.addSubview(addButton)
        addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -10).isActive = true
        addButton.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -10).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
    }
    func updateLocationName(_ mapItem: MKMapItem) {
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

                  }
                    let averageN = totalNeurological / Double(querySnapshot!.documents.count)
                    let averageM = totalMobility / Double(querySnapshot!.documents.count)
                    let averageS = totalSensory / Double(querySnapshot!.documents.count)
                    self.mobilityButton.setMainText("\(averageM.rounded())")
                    self.sensoryButton.setMainText("\(averageS.rounded())")
                    self.neurologicalButton.setMainText("\(averageN.rounded())")
                }
              }
    }
    func setWebsiteURl(_ url: String) {
        websiteURL = url
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
        mobilityButton.translatesAutoresizingMaskIntoConstraints = false
        mobilityView.addSubview(mobilityButton)
        mobilityButton.centerXAnchor.constraint(equalTo: mobilityView.centerXAnchor).isActive = true
        mobilityButton.centerYAnchor.constraint(equalTo: mobilityView.centerYAnchor,constant: -10).isActive = true
        
        // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
        neurologicalView.addSubview(neurologicalButton)
        neurologicalButton.centerXAnchor.constraint(equalTo: neurologicalView.centerXAnchor).isActive = true
        neurologicalButton.centerYAnchor.constraint(equalTo: neurologicalView.centerYAnchor,constant: -10).isActive = true
        
        websiteView.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        websiteView.translatesAutoresizingMaskIntoConstraints = false
        websiteView.layer.cornerRadius = 10
        view.addSubview(websiteView)
        websiteView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        websiteView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:130).isActive = true
        websiteView.widthAnchor.constraint(equalToConstant: 97).isActive = true
        websiteView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        let websiteButton = ImageButton()
        websiteButton.setMainImage(UIImage(named: "phone")!)
        websiteButton.setAdditionalText("Website")
        websiteButton.translatesAutoresizingMaskIntoConstraints = false
        websiteView.addSubview(websiteButton)
        websiteButton.centerXAnchor.constraint(equalTo: websiteView.centerXAnchor).isActive = true
        websiteButton.centerYAnchor.constraint(equalTo: websiteView.centerYAnchor,constant: -10).isActive = true
        websiteButton.addTarget(self, action: #selector(websiteButtonTap), for: .touchUpInside)
        directionView.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        directionView.translatesAutoresizingMaskIntoConstraints = false
        directionView.layer.cornerRadius = 10
        view.addSubview(directionView)
        directionView.leadingAnchor.constraint(equalTo: websiteView.trailingAnchor, constant: 20).isActive = true
        directionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:130).isActive = true
        directionView.widthAnchor.constraint(equalToConstant: 133).isActive = true
        directionView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        let directionButton = ImageButton()
        directionButton.setMainImage(UIImage(named: "phone")!)
        directionButton.setAdditionalText("Directions")
        directionButton.translatesAutoresizingMaskIntoConstraints = false
        directionView.addSubview(directionButton)
        directionButton.centerXAnchor.constraint(equalTo: directionView.centerXAnchor).isActive = true
        directionButton.centerYAnchor.constraint(equalTo: directionView.centerYAnchor,constant: -10).isActive = true
        
        phoneView.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
        phoneView.translatesAutoresizingMaskIntoConstraints = false
        phoneView.layer.cornerRadius = 10
        view.addSubview(phoneView)
        phoneView.leadingAnchor.constraint(equalTo: directionView.trailingAnchor, constant: 20).isActive = true
        phoneView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:130).isActive = true
        phoneView.widthAnchor.constraint(equalToConstant: 97).isActive = true
        phoneView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        let phoneButton = ImageButton()
        phoneButton.setMainImage(UIImage(named: "phone")!)
        phoneButton.setAdditionalText("Phone")
        phoneButton.translatesAutoresizingMaskIntoConstraints = false
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
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:235).isActive = true
        tableView.widthAnchor.constraint(equalToConstant: 380).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 60).isActive = true
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

    @objc func addButtonTapped() {
        let reviewVC = AddReviewViewController(latitude: location.placemark.coordinate.latitude, longitude: location.placemark.coordinate.longitude)
        reviewVC.delegate = self
        self.present(reviewVC, animated: true, completion: nil)
    }
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
        
    }
    @objc func showMobilityStats() {
        print("mymobility")
    }
    
    
}


