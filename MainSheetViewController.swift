//
//  SecondViewController.swift
//  MapDemo
//
//  Created by Sam Pan on 11/6/23.
//  Copyright © 2023 Todd Sproull. All rights reserved.
//

import UIKit

class MainSheetViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
//    let searchBar = UISearchBar()
    let profilePicture = UIButton()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let tripCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let savedTripFrame = UIView(frame: CGRect(x: 22, y: 227, width: 350, height: 120))
    
    var isDropDownVisible = true
    var favorites:[String] = []

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return favorites.count + 1
        }
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            if indexPath.row < favorites.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
                cell.contentView.backgroundColor = UIColor(red: 255/255, green: 68/255, blue: 61/255, alpha: 1)
                cell.layer.cornerRadius = min(cell.frame.size.height, cell.frame.size.width) / 2.0
                cell.layer.masksToBounds = true
                
                let button = UIButton(type: .system)
                button.backgroundColor = .clear // Make the button background clear
//                button.addTarget(self, action: #selector(cellButtonTapped), for: .touchUpInside)

                
                let pinImageView = UIImageView(image: UIImage(named: "Pin"))
                cell.contentView.addSubview(pinImageView)
                cell.contentView.addSubview(button)
                
                let labelText = favorites[indexPath.row]
                            
                let labelHeight: CGFloat = 20
                let label = UILabel(frame: CGRect(x: 0, y: cell.frame.size.height, width: cell.frame.size.width, height: labelHeight))
                label.textAlignment = .center
                label.textColor = .black
                label.font = UIFont.systemFont(ofSize: 12) // Adjust font size as needed
                label.text = labelText
                           
                let labelY = cell.frame.origin.y + cell.frame.size.height
                           
                label.frame.origin.y = labelY
                label.frame.origin.x = cell.frame.origin.x
                           
                collectionView.addSubview(label)
                
                pinImageView.translatesAutoresizingMaskIntoConstraints = false
                pinImageView.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor).isActive = true
                pinImageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
                pinImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
                pinImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
                
                button.translatesAutoresizingMaskIntoConstraints = false
                button.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive = true
                button.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive = true
                button.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor).isActive = true
                button.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true

                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCell", for: indexPath)
                cell.layer.cornerRadius = min(cell.frame.size.height, cell.frame.size.width) / 2.0
                cell.layer.masksToBounds = true

                let button = UIButton(type: .system)
                button.setTitle("+", for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
                button.frame = cell.contentView.bounds
                button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
                
                cell.contentView.addSubview(button)
                return cell
            }
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TripCell", for: indexPath)
            cell.contentView.backgroundColor = .blue
            cell.layer.cornerRadius = min(cell.frame.size.height, cell.frame.size.width) / 2.0
            cell.layer.masksToBounds = true
            return cell
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        setupCollectionView()

        if #available(iOS 15.0, *) {
//            searchBar.placeholder = "Search..."
//            self.view.addSubview(searchBar)
//            searchBar.translatesAutoresizingMaskIntoConstraints = false
//            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -20).isActive = true
//            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -27).isActive = true
//            searchBar.heightAnchor.constraint(equalToConstant: 45).isActive = true
//            searchBar.widthAnchor.constraint(equalToConstant: 320).isActive = true
//            searchBar.layer.borderWidth = 1
//            searchBar.layer.borderColor = UIColor(red: 255/255, green: 253/255, blue: 247/255, alpha: 1.0).cgColor
//            searchBar.delegate = self
            
            profilePicture.setImage(UIImage(named: "profile"), for: .normal)
            profilePicture.translatesAutoresizingMaskIntoConstraints = false
            profilePicture.contentMode = .scaleAspectFit
            profilePicture.addTarget(self, action: #selector(profilePictureTapped), for: .touchUpInside)
            view.addSubview(profilePicture)
            profilePicture.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -15).isActive = true
            profilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 155).isActive = true
            profilePicture.heightAnchor.constraint(equalToConstant: 35).isActive = true
            profilePicture.widthAnchor.constraint(equalToConstant: 35).isActive = true
            profilePicture.accessibilityLabel = "Profile Picture. Click to View Profile."
            
            let favLabel = UILabel()
            favLabel.text = "Favorites"
            favLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(favLabel)
            favLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
            favLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
            favLabel.textColor = UIColor(red: 110/255, green: 108/255, blue: 103/255, alpha: 1)
            
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
            collectionView.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
            collectionView.layer.cornerRadius = 10
            collectionView.accessibilityLabel = "Here are your favorite locations, ordered chronologically from left to right"
            view.addSubview(collectionView)
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 8
            layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
            layout.itemSize = CGSize(width: 60, height: 60)
            

            collectionView.collectionViewLayout = layout
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.topAnchor.constraint(equalTo: favLabel.bottomAnchor, constant:5).isActive = true
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            collectionView.reloadData()
            collectionView.widthAnchor.constraint(equalToConstant: 350).isActive = true
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ButtonCell")
//            
//            savedTripFrame.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
//            savedTripFrame.layer.cornerRadius = 10
//            view.addSubview(savedTripFrame)
            
//
//            let tripToggleLabel = UILabel()
//            tripToggleLabel.text = "Toggle Trips"
//            tripToggleLabel.isUserInteractionEnabled = true
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleTripCollectionView))
//            tripToggleLabel.addGestureRecognizer(tapGesture)
//            tripToggleLabel.textColor = .blue
//            savedTripFrame.addSubview(tripToggleLabel)
//
//            tripToggleLabel.translatesAutoresizingMaskIntoConstraints = false
//            tripToggleLabel.topAnchor.constraint(equalTo: savedTripFrame.topAnchor, constant:10).isActive = true
//            tripToggleLabel.leadingAnchor.constraint(equalTo: savedTripFrame.leadingAnchor, constant: 5).isActive = true
//            tripToggleLabel.layer.zPosition = 1
//
//            tripCollectionView.translatesAutoresizingMaskIntoConstraints = false
//            tripCollectionView.delegate = self
//            tripCollectionView.dataSource = self
//            tripCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "TripCell")
//            tripCollectionView.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1)
//            tripCollectionView.layer.cornerRadius = 10
//            savedTripFrame.addSubview(tripCollectionView)
//            tripCollectionView.topAnchor.constraint(equalTo: tripToggleLabel.topAnchor, constant:10).isActive = true
//            tripCollectionView.centerXAnchor.constraint(equalTo: savedTripFrame.centerXAnchor).isActive = true
//            tripCollectionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//            tripCollectionView.widthAnchor.constraint(equalToConstant: 350).isActive = true
//
//            let layout2 = UICollectionViewFlowLayout()
//            layout2.scrollDirection = .horizontal
//            layout2.minimumInteritemSpacing = 8
//            layout2.minimumLineSpacing = 8
//            layout2.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
//            layout2.itemSize = CGSize(width: 60, height: 60)
//            tripCollectionView.collectionViewLayout = layout2
            
        } else {
            // Fallback on earlier versions
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        searchBar.clipsToBounds = true
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true
        profilePicture.layer.borderWidth = 1
        profilePicture.layer.borderColor = UIColor.black.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let favoritedLocations = UserDefaults.standard.stringArray(forKey: "favoritedLocations") {
            favorites = favoritedLocations
            collectionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        } else {
            favorites = []
            collectionView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
        collectionView.reloadData()
    }
    
    @objc func addButtonTapped() {
        print("Uh oh. An error occured.")
    }
    
    @objc func cellButtonTapped() {
        let vc = LocationViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .pageSheet
            
        if #available(iOS 16.0, *) {
            if let sheet = navVC.sheetPresentationController {
                sheet.preferredCornerRadius = 10
                sheet.detents = [.custom(resolver: { context in
                    0.45  * context.maximumDetentValue
                    }),.custom(resolver: { context in
                    0.06 * context.maximumDetentValue
                    }),.medium()]
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.selectedDetentIdentifier = .medium
                sheet.prefersGrabberVisible = true
                sheet.largestUndimmedDetentIdentifier = .large
                }
            }
        navigationController?.present(navVC, animated:true)
    }
    
    @objc func profilePictureTapped() {
        let vc = ProfileViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .pageSheet
            
        if #available(iOS 16.0, *) {
            if let sheet = navVC.sheetPresentationController {
                sheet.preferredCornerRadius = 10
                sheet.detents = [.custom(resolver: { context in
                    0.4  * context.maximumDetentValue
                    })]
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                }
            }
        navigationController?.present(navVC, animated:true)
    }
    
    @objc func toggleTripCollectionView() {
        isDropDownVisible.toggle()
        UIView.animate(withDuration: 0.3) {
            if self.isDropDownVisible { // makes it appear
                print("Togg")
                self.savedTripFrame.frame.size.height = 120
                self.tripCollectionView.transform = CGAffineTransform.identity // Restore to original size
            } else {
                self.savedTripFrame.frame.size.height = 40
                let scaleDownTransform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.tripCollectionView.transform = scaleDownTransform
            }

            self.tripCollectionView.isHidden = !self.isDropDownVisible
        }
    }
    func setupCollectionView() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0) // Adjust bottom inset as needed
            flowLayout.minimumLineSpacing = 10
        }
    }

}
