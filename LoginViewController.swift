//
//  LoginViewController.swift
//  Uplift
//
//  Created by Eric Wang on 11/17/23.
//

import Foundation

import UIKit
import FirebaseCore
import FirebaseFirestore

class LoginViewController: UIViewController {
    var db: Firestore!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerNowButton: UIButton!
    var usernameText: String = ""
    var passwordText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize Firestore
        db = Firestore.firestore()
        
        
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        print("LOGIN PRESSED")
//        print(usernameTextField.text)
//        print(passwordTextField.text)
        
        //TODO: evaluate if the username and password is valid and check from firebase, if yes then perform segue. If not, stop the view
        // Reference to the "users" collection
        
        let usersRef = db.collection("users")
        // Perform a query to get documents from the "users" collection
        usersRef
            .whereField("username", isEqualTo: usernameTextField.text ?? "")
            .whereField("password", isEqualTo: passwordTextField.text ?? "")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                  print("Error getting documents: \(err)")
                } else {
                  for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                      //got data, push segue
                      UserManager.shared.username = self.usernameTextField.text
                      UserManager.shared.name = document.data()["name"] as? String
                      UserManager.shared.email = document.data()["email"] as? String
                      UserManager.shared.numberOfContributions = document.data()["contributions"] as? Int

                      self.performSegue(withIdentifier: "loginSegueIdentifier", sender: self)

                  }
                }
              }
        
        
    }
    
    

}
