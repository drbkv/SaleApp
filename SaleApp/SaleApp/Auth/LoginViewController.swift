//import UIKit
//import Firebase
//
//
//
//class LoginViewController: UIViewController {
//
//    let emailTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Email"
//        textField.borderStyle = .roundedRect
//        textField.layer.shadowColor = UIColor.black.cgColor
//        textField.layer.shadowOffset = CGSize(width: 0, height: 1)
//        textField.layer.shadowOpacity = 0.2
//        textField.layer.shadowRadius = 4.0
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        return textField
//    }()
//
//    let passwordTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Password"
//        textField.isSecureTextEntry = true
//        textField.borderStyle = .roundedRect
//        textField.layer.shadowColor = UIColor.black.cgColor
//        textField.layer.shadowOffset = CGSize(width: 0, height: 1)
//        textField.layer.shadowOpacity = 0.2
//        textField.layer.shadowRadius = 4.0
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        return textField
//    }()
//    
//    // Property to store user data
//    var userData: UserData?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//
//        setupViews()
//    }
//
//    func setupViews() {
//        let titleLabel = UILabel()
//        titleLabel.text = "Login"
//        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(titleLabel)
//        
//        view.addSubview(emailTextField)
//        view.addSubview(passwordTextField)
//
//        NSLayoutConstraint.activate([
//            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
//
//            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
//            emailTextField.widthAnchor.constraint(equalToConstant: 250),
//            emailTextField.heightAnchor.constraint(equalToConstant: 40),
//
//            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
//            passwordTextField.widthAnchor.constraint(equalToConstant: 250),
//            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
//        ])
//
//        let loginButton: UIButton = {
//            let button = UIButton(type: .system)
//            button.setTitle("Login", for: .normal)
//            button.setTitleColor(.white, for: .normal)
//            button.backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0) // Dark green color
//            button.layer.cornerRadius = 5
//            button.layer.shadowColor = UIColor.black.cgColor
//            button.layer.shadowOffset = CGSize(width: 0, height: 1)
//            button.layer.shadowOpacity = 0.2
//            button.layer.shadowRadius = 4.0
//            button.translatesAutoresizingMaskIntoConstraints = false
//            button.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
//            return button
//        }()
//
//        view.addSubview(loginButton)
//
//        NSLayoutConstraint.activate([
//            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
//            loginButton.widthAnchor.constraint(equalToConstant: 250),
//            loginButton.heightAnchor.constraint(equalToConstant: 40)
//        ])
//
//        let registrationButton: UIButton = {
//            let button = UIButton(type: .system)
//            button.setTitle("Registration", for: .normal)
//            button.setTitleColor(.black, for: .normal)
//            button.layer.shadowColor = UIColor.black.cgColor
//            button.layer.shadowOffset = CGSize(width: 0, height: 1)
//            button.layer.shadowOpacity = 0.2
//            button.layer.shadowRadius = 4.0
//            button.translatesAutoresizingMaskIntoConstraints = false
//            button.addTarget(self, action: #selector(registrationButtonTapped(_:)), for: .touchUpInside)
//            return button
//        }()
//
//        view.addSubview(registrationButton)
//
//        NSLayoutConstraint.activate([
//            registrationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            registrationButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
//        ])
//    }
//
//    @objc func loginButtonTapped(_ sender: UIButton) {
//        guard let email = emailTextField.text, !email.isEmpty,
//              let password = passwordTextField.text, !password.isEmpty else {
//            let alert = UIAlertController(title: "Ошибка", message: "Введите email и пароль", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            present(alert, animated: true, completion: nil)
//            return
//        }
//
//        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
//            guard let self = self else { return }
//            if let error = error {
//                print("Login error: \(error)")
//                let alert = UIAlertController(title: "Ошибка", message: "Неверный email или пароль", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//                return
//            }
//            
//            guard let userId = authResult?.user.uid else {
//                let alert = UIAlertController(title: "Ошибка", message: "Не удалось получить идентификатор пользователя", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//                return
//            }
//            
//            let databaseReference = Database.database().reference()
//            databaseReference.child("users").child(userId).observeSingleEvent(of: .value) { (snapshot, error) in
//                guard let userDataDict = snapshot.value as? [String: Any] else {
//                    let alert = UIAlertController(title: "Ошибка", message: "Не удалось получить данные пользователя", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                    return
//                }
//                
//                let userData = UserData(
//                    userId: userId,
//                    email: userDataDict["email"] as? String ?? "",
//                    name: userDataDict["name"] as? String ?? "",
//                    surname: userDataDict["surname"] as? String ?? "",
//                    dateOfBirth: userDataDict["dateOfBirth"] as? String ?? ""
//                )
//                
//                let mainTabBarController = MainTabBarController()
//                if let profileViewController = mainTabBarController.viewControllers?.first as? MyProfileViewController {
//                    profileViewController.userData = userData
//                }
//                UIApplication.shared.keyWindow?.rootViewController = mainTabBarController
//                UIApplication.shared.keyWindow?.makeKeyAndVisible()
//            }
//        }
//    }
//
//    @objc func registrationButtonTapped(_ sender: UIButton) {
//        let registrationVC = RegistrationViewController()
//        let navController = UINavigationController(rootViewController: registrationVC)
//        present(navController, animated: true, completion: nil)
//    }
//}
//
import UIKit
import Firebase

class LoginViewController: UIViewController {

    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 1)
        textField.layer.shadowOpacity = 0.2
        textField.layer.shadowRadius = 4.0
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = UIImageView(image: UIImage(systemName: "envelope"))
        textField.leftViewMode = .always
        return textField
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 1)
        textField.layer.shadowOpacity = 0.2
        textField.layer.shadowRadius = 4.0
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = UIImageView(image: UIImage(systemName: "lock"))
        textField.leftViewMode = .always
        return textField
    }()
    
    var userData: UserData?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupViews()
    }

    func setupBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.systemTeal.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    func setupViews() {
        let titleLabel = UILabel()
        titleLabel.text = "Login"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),

            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            emailTextField.widthAnchor.constraint(equalToConstant: 250),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),

            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: 250),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
        ])

        let loginButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Login", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor.systemBlue
            button.layer.cornerRadius = 5
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 1)
            button.layer.shadowOpacity = 0.2
            button.layer.shadowRadius = 4.0
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
            return button
        }()

        view.addSubview(loginButton)

        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.widthAnchor.constraint(equalToConstant: 250),
            loginButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        let registrationButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Register", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 1)
            button.layer.shadowOpacity = 0.2
            button.layer.shadowRadius = 4.0
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(registrationButtonTapped(_:)), for: .touchUpInside)
            return button
        }()

        view.addSubview(registrationButton)

        NSLayoutConstraint.activate([
            registrationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registrationButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
        ])
    }

    @objc func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Please enter email and password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }

        // Animation on button tap
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                sender.transform = CGAffineTransform.identity
            }
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                print("Login error: \(error)")
                let alert = UIAlertController(title: "Error", message: "Invalid email or password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            guard let userId = authResult?.user.uid else {
                let alert = UIAlertController(title: "Error", message: "Unable to get user ID", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let databaseReference = Database.database().reference()
            databaseReference.child("users").child(userId).observeSingleEvent(of: .value) { (snapshot, error) in
                guard let userDataDict = snapshot.value as? [String: Any] else {
                    let alert = UIAlertController(title: "Error", message: "Unable to fetch user data", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                let userData = UserData(
                    userId: userId,
                    email: userDataDict["email"] as? String ?? "",
                    name: userDataDict["name"] as? String ?? "",
                    surname: userDataDict["surname"] as? String ?? "",
                    dateOfBirth: userDataDict["dateOfBirth"] as? String ?? ""
                )
                
                let mainTabBarController = MainTabBarController()
                if let profileViewController = mainTabBarController.viewControllers?.first as? MyProfileViewController {
                    profileViewController.userData = userData
                }
                UIApplication.shared.keyWindow?.rootViewController = mainTabBarController
                UIApplication.shared.keyWindow?.makeKeyAndVisible()
            }
        }
    }

    @objc func registrationButtonTapped(_ sender: UIButton) {
        let registrationVC = RegistrationViewController()
        let navController = UINavigationController(rootViewController: registrationVC)
        present(navController, animated: true, completion: nil)
    }
}
