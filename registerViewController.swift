//
//  registerViewController.swift
//  Uplift
//
//  Created by Mohammed Ali on 11/20/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class registerViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordTextFieldConfirmation: UITextField!
    var db: Firestore!
    
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        nameTextField.delegate = self
        usernameTextField.delegate = self
        emailAddressTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextFieldConfirmation.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        guard let name = nameTextField.text,
            let username = usernameTextField.text,
            let email = emailAddressTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = passwordTextFieldConfirmation.text else {
            // Handle incomplete form
            return
        }
        // Check if passwords match
        if password != confirmPassword {
            // Handle password mismatch
            return
        }
        // Check if a user already exists with the given username
                checkUsernameAvailability(username: username) { isAvailable in
                    if isAvailable {
                        // Username is available, proceed with registration
                        self.registerUser(name: name, username: username, email: email, password: password)
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        // Username is not available, handle accordingly
                        // You can show an alert or update the UI to inform the user
                    }
                }
        
    }
    func checkUsernameAvailability(username: String, completion: @escaping (Bool) -> Void) {
            let usersRef = db.collection("users")
            usersRef.whereField("username", isEqualTo: username).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error checking username availability: \(error.localizedDescription)")
                    completion(false)
                } else {
                    // Check if any documents exist with the given username
                    completion(snapshot?.documents.isEmpty ?? true)
                }
            }
        }

        func registerUser(name: String, username: String, email: String, password: String) {
            let usersRef = db.collection("users")
            
            let userData = ["name": name, "username": username, "email": email, "password": password, "contributions": 0] as [String : Any]

            usersRef.addDocument(data: userData) { error in
                if let error = error {
                    print("Error adding user to Firestore: \(error.localizedDescription)")
                    // Handle registration failure, show an alert or update the UI
                } else {
                    // Registration successful, you can navigate to the next screen or perform other actions
                    print("User registered successfully!")
                    
                    
                }
            }
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
