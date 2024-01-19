import UIKit
import FirebaseCore
import FirebaseFirestore

class ProfileViewController: UIViewController {
    
    let profileImage = UIImageView()
    let profileName = UILabel()
    let emailLabel = UILabel()
    let contributionsLabel = UILabel()
    let logoutButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupInfo()
        setupContributions()
    }
    
    func setupInfo() {
        profileImage.image = UIImage(named: "profile")
        profileImage.layer.cornerRadius = 10
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImage)
        profileImage.widthAnchor.constraint(equalToConstant: 35).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 35).isActive = true
        profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -30).isActive = true
        profileImage.accessibilityLabel = "Here is a profile image of yourself."
        
        profileName.text = UserManager.shared.username
        profileName.font = UIFont.boldSystemFont(ofSize: 20)
        profileName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileName)
        profileName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10).isActive = true
        profileName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -35).isActive = true
        
        emailLabel.text = UserManager.shared.email
        emailLabel.font = UIFont.systemFont(ofSize: 13)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailLabel)
        emailLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10).isActive = true
        emailLabel.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 4).isActive = true
    }
    
    func setupContributions() {
        contributionsLabel.text = "Number of Contributions: \(UserManager.shared.numberOfContributions ?? 0)"
        contributionsLabel.font = UIFont.systemFont(ofSize: 15)
        contributionsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contributionsLabel)
        contributionsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        contributionsLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20).isActive = true
        contributionsLabel.accessibilityLabel = "This lists the number of times you've contributed to the Uplift Community."
    }
    
    

}
