//
//  AddReviewViewController.swift
//  Uplift
//
//  Created by Sam Pan on 11/29/23.
//
import UIKit

import FirebaseCore
import FirebaseFirestore
protocol AddReviewDelegate: AnyObject {
    func didSubmitReview(withAverages averages: (Double, Double, Double))
}

class AddReviewViewController: UIViewController, UITextFieldDelegate {
    var latitude = 0.0
    var longitude = 0.0
    var db: Firestore!
    weak var delegate: AddReviewDelegate?
    convenience init(latitude: Double, longitude: Double) {
        self.init()
        self.latitude = latitude
        self.longitude = longitude
        // Additional setup if needed
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()

        view.backgroundColor = .white
        
        let sliderNames = ["Mobility", "Neurological", "Sensory"]
        let sliderCount = sliderNames.count
        let sliderHeight: CGFloat = 31
        let spacing: CGFloat = 20
                
        let totalHeight = CGFloat(sliderCount) * (sliderHeight + spacing) - spacing
        let startY = (view.bounds.height - totalHeight) / 2
            
        for i in 0..<sliderCount {
            let slider = UISlider(frame: CGRect(x: 20, y: startY + CGFloat(i) * (sliderHeight + spacing), width: view.bounds.width - 40, height: sliderHeight))
            slider.tag = i + 1
            slider.minimumValue = 0
            slider.maximumValue = 100
            slider.value = 50
            slider.accessibilityLabel = String(slider.value)
            let label = UILabel(frame: CGRect(x: 20, y: startY + CGFloat(i) * (sliderHeight + spacing) - 20, width: 100, height: 20))
            label.textAlignment = .center
            label.text = sliderNames[i]
            label.accessibilityLabel = "Slide this slider back and forth to score this location on a scale of 1 to 100 from left to right on the topic of \(sliderNames[i])"
            
            view.addSubview(slider)
            view.addSubview(label)
        }
        let reviewTextField = UITextField(frame: CGRect(x: 20, y: startY - 80, width: view.bounds.width - 40, height: 40))
        reviewTextField.placeholder = "Enter your review here"
        reviewTextField.borderStyle = .roundedRect
        reviewTextField.tag = 20 // Assign a tag to identify the text field
        reviewTextField.delegate = self
        view.addSubview(reviewTextField)
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        submitButton.frame = CGRect(x: 20, y: startY + CGFloat(sliderCount) * (sliderHeight + spacing), width: view.bounds.width - 40, height: 50)
        
        view.addSubview(submitButton)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func submitButtonTapped() {
        var sliderValues: [String: Float] = [:]
        let sliderNames = ["Mobility", "Neurological", "Sensory"]

        for i in 0..<sliderNames.count {
            if let slider = view.viewWithTag(i + 1) as? UISlider {
                sliderValues[sliderNames[i]] = slider.value
            }
        }
        var reviewText = ""
        let reviewTextField = view.viewWithTag(20) as? UITextField
        
        reviewText = reviewTextField?.text ?? ""
        
        print("Slider Values: \(sliderValues)")
        let reviews = db.collection("reviews")
        
        let reviewData = ["username": UserManager.shared.username ?? "", "latitude": latitude, "longitude": longitude, "mobility": sliderValues["Mobility"]!, "sensory": sliderValues["Sensory"]!, "neurological": sliderValues["Neurological"]!, "review": reviewText] as [String : Any]

        reviews.addDocument(data: reviewData) { error in
            if let error = error {
                print("Error adding review to Firestore: \(error.localizedDescription)")
            } else {
                
                print("Added review!")
                let averages = (Double(sliderValues["Neurological"]!), Double(sliderValues["Mobility"]!), Double(sliderValues["Sensory"]!))
                self.delegate?.didSubmitReview(withAverages: averages)
                self.dismiss(animated: true, completion: nil)

            }
        }
        //add 1 to contributions
        let usersRef = db.collection("users")
            usersRef
                .whereField("username", isEqualTo: UserManager.shared.username ?? "")
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            var contributions = document.data()["contributions"] as? Int ?? 0
                            contributions += 1

                            usersRef.document(document.documentID).updateData(["contributions": contributions])
                    }
            }
        }
    }
}
