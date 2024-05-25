//
//import UIKit
//import Firebase
//
//class RegistrationViewController: UIViewController {
//    
//    let nameTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Name"
//        textField.borderStyle = .roundedRect
//        textField.layer.shadowColor = UIColor.black.cgColor
//        textField.layer.shadowOffset = CGSize(width: 0, height: 1)
//        textField.layer.shadowOpacity = 0.2
//        textField.layer.shadowRadius = 4.0
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        return textField
//    }()
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
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupViews()
//    }
//    
//    func setupViews() {
//        let titleLabel = UILabel()
//        titleLabel.text = "Registration"
//        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(titleLabel)
//        
//        view.addSubview(nameTextField)
//        view.addSubview(emailTextField)
//        view.addSubview(passwordTextField)
//        
//        NSLayoutConstraint.activate([
//            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
//            
//            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
//            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            nameTextField.widthAnchor.constraint(equalToConstant: 250),
//            nameTextField.heightAnchor.constraint(equalToConstant: 40),
//            
//            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
//            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            emailTextField.widthAnchor.constraint(equalToConstant: 250),
//            emailTextField.heightAnchor.constraint(equalToConstant: 40),
//            
//            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
//            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            passwordTextField.widthAnchor.constraint(equalToConstant: 250),
//            passwordTextField.heightAnchor.constraint(equalToConstant: 40)
//        ])
//        
//        let darkGreenColor = UIColor(red: 0, green: 0.5, blue: 0, alpha: 1.0)
//        
//        let registerButton: UIButton = {
//            let button = UIButton(type: .system)
//            button.setTitle("Register", for: .normal)
//            button.backgroundColor = darkGreenColor
//            button.setTitleColor(.white, for: .normal)
//            button.layer.cornerRadius = 5
//            button.layer.shadowColor = UIColor.black.cgColor
//            button.layer.shadowOffset = CGSize(width: 0, height: 1)
//            button.layer.shadowOpacity = 0.2
//            button.layer.shadowRadius = 4.0
//            button.addTarget(self, action: #selector(registerButtonTapped(_:)), for: .touchUpInside)
//            button.translatesAutoresizingMaskIntoConstraints = false
//            return button
//        }()
//        
//        view.addSubview(registerButton)
//        NSLayoutConstraint.activate([
//            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
//            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            registerButton.widthAnchor.constraint(equalToConstant: 250),
//            registerButton.heightAnchor.constraint(equalToConstant: 40)
//        ])
//    }
//    
//    @objc func registerButtonTapped(_ sender: UIButton) {
//        guard let email = emailTextField.text, !email.isEmpty,
//              let password = passwordTextField.text, !password.isEmpty,
//              let name = nameTextField.text, !name.isEmpty else {
//            let alert = UIAlertController(title: "Ошибка", message: "Заполните все поля", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            present(alert, animated: true, completion: nil)
//            return
//        }
//        
//        if !isValidEmail(email) {
//            let alert = UIAlertController(title: "Ошибка", message: "Введите корректный email", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            present(alert, animated: true, completion: nil)
//            return
//        }
//        
//        let registrationManager = RegistrationManager.shared
//        registrationManager.registerUser(email: email, password: password, name: name) { [weak self] error in
//            if let error = error {
//                print("Registration error: \(error.localizedDescription)")
//                let alert = UIAlertController(title: "Ошибка регистрации", message: error.localizedDescription, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self?.present(alert, animated: true, completion: nil)
//                return
//            } else {
//                // Adding a delay before signing in to handle timing issues
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
//                        if let error = error {
//                            print("Login error: \(error.localizedDescription)")
//                            let alert = UIAlertController(title: "Ошибка входа", message: error.localizedDescription, preferredStyle: .alert)
//                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                            self?.present(alert, animated: true, completion: nil)
//                            return
//                        }
//                        
//                        DispatchQueue.main.async {
//                            let alert = UIAlertController(title: "Успешная регистрация", message: "Вы успешно зарегистрировались", preferredStyle: .alert)
//                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//                                self?.dismiss(animated: true) {
//                                    let loginVC = LoginViewController()
//                                    self?.present(loginVC, animated: true, completion: nil)
//                                }
//                            }))
//                            self?.present(alert, animated: true, completion: nil)
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    func isValidEmail(_ email: String) -> Bool {
//        // Простая проверка формата email с помощью регулярного выражения
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        return emailPred.evaluate(with: email)
//    }
//}


import UIKit
import Firebase
class RegistrationViewController: UIViewController {
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.borderStyle = .roundedRect
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 1)
        textField.layer.shadowOpacity = 0.2
        textField.layer.shadowRadius = 4.0
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
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
        titleLabel.text = "Registration"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalToConstant: 250),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalToConstant: 250),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalToConstant: 250),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let darkGreenColor = UIColor(red: 0, green: 0.5, blue: 0, alpha: 1.0)
        
        let registerButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Register", for: .normal)
            button.backgroundColor = darkGreenColor
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 5
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 1)
            button.layer.shadowOpacity = 0.2
            button.layer.shadowRadius = 4.0
            button.addTarget(self, action: #selector(registerButtonTapped(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        view.addSubview(registerButton)
        NSLayoutConstraint.activate([
            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.widthAnchor.constraint(equalToConstant: 250),
            registerButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func registerButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let name = nameTextField.text, !name.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Please fill all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        if !isValidEmail(email) {
            let alert = UIAlertController(title: "Error", message: "Please enter a valid email", preferredStyle: .alert)
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

        let registrationManager = RegistrationManager.shared
        registrationManager.registerUser(email: email, password: password, name: name) { [weak self] error in
            if let error = error {
                print("Registration error: \(error.localizedDescription)")
                let alert = UIAlertController(title: "Registration Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                return
            } else {
                // Adding a delay before signing in to handle timing issues
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            print("Login error: \(error.localizedDescription)")
                            let alert = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self?.present(alert, animated: true, completion: nil)
                            return
                        }
                        
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Registration Successful", message: "You have successfully registered", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                                self?.dismiss(animated: true) {
                                    let loginVC = LoginViewController()
                                    self?.present(loginVC, animated: true, completion: nil)
                                }
                            }))
                            self?.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
