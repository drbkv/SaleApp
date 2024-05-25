import UIKit
import Firebase

class MyProfileViewController: UIViewController {
    var userData: UserData?

    // UI Elements
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "My Profile"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let nameTextField = MyProfileViewController.createTextField(placeholder: "Enter your name")
    let surnameTextField = MyProfileViewController.createTextField(placeholder: "Enter your surname")
    let emailTextField = MyProfileViewController.createTextField(placeholder: "Enter your email")
    let phoneNumberTextField = MyProfileViewController.createTextField(placeholder: "Enter your phone number")
    let dateOfBirthTextField = MyProfileViewController.createTextField(placeholder: "Enter your date of birth")

    let editButton = MyProfileViewController.createButton(title: "Edit", action: #selector(editButtonTapped(_:)), target: self)
    let saveButton = MyProfileViewController.createButton(title: "Save", action: #selector(saveButtonTapped(_:)), target: self)
    let deletedListingsButton = MyProfileViewController.createButton(title: "Удаленные объявления", action: #selector(deletedListingsButtonTapped(_:)), target: self, backgroundColor: UIColor(red: 0.0, green: 0.7, blue: 0.0, alpha: 1.0))
    let archivedListingsButton = MyProfileViewController.createButton(title: "Объявления в архиве", action: #selector(archivedListingsButtonTapped(_:)), target: self, backgroundColor: UIColor(red: 0.0, green: 0.5, blue: 0.8, alpha: 1.0))
    let logoutButton = MyProfileViewController.createButton(title: "LogOut", action: #selector(logoutButtonTapped(_:)), target: self, backgroundColor: UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1.0))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupViews()
        loadUserData()
    }

    func setupViews() {
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        
        let nameLabelStackView = createLabelStackView(title: "Name", textField: nameTextField, iconName: "person.fill")
        let surnameLabelStackView = createLabelStackView(title: "Surname", textField: surnameTextField, iconName: "person.fill")
        let emailLabelStackView = createLabelStackView(title: "Email", textField: emailTextField, iconName: "envelope.fill")
        let phoneNumberLabelStackView = createLabelStackView(title: "Phone Number", textField: phoneNumberTextField, iconName: "phone.fill")
        let dobLabelStackView = createLabelStackView(title: "Date of Birth", textField: dateOfBirthTextField, iconName: "calendar.fill")

        let inputFieldsStackView = UIStackView(arrangedSubviews: [
            nameLabelStackView,
            surnameLabelStackView,
            emailLabelStackView,
            phoneNumberLabelStackView,
            dobLabelStackView
        ])
        inputFieldsStackView.axis = .vertical
        inputFieldsStackView.spacing = 20
        inputFieldsStackView.translatesAutoresizingMaskIntoConstraints = false

        let buttonStackView = UIStackView(arrangedSubviews: [editButton, saveButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 20
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false

        let mainStackView = UIStackView(arrangedSubviews: [
            inputFieldsStackView,
            buttonStackView,
            deletedListingsButton,
            archivedListingsButton,
            logoutButton
        ])
        mainStackView.axis = .vertical
        mainStackView.spacing = 20
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(mainStackView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 120),

            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 40),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }

    func createLabelStackView(title: String, textField: UITextField, iconName: String) -> UIStackView {
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black

        let iconImageView = UIImageView(image: UIImage(systemName: iconName))
        iconImageView.tintColor = .gray
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        let containerView = UIView()
        containerView.addSubview(iconImageView)
        containerView.addSubview(label)
        containerView.addSubview(textField)

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),

            label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            textField.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            textField.topAnchor.constraint(equalTo: containerView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        containerView.translatesAutoresizingMaskIntoConstraints = false

        return UIStackView(arrangedSubviews: [containerView])
    }

    static func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isEnabled = false
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 1)
        textField.layer.shadowOpacity = 0.2
        textField.layer.shadowRadius = 4.0
        textField.layer.cornerRadius = 8.0
        return textField
    }

    static func createButton(title: String, action: Selector, target: Any, backgroundColor: UIColor = .systemBlue) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = backgroundColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4.0
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return button
    }

    func loadUserData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        let ref = Database.database().reference().child("users").child(userId)
        ref.observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let self = self, let userData = snapshot.value as? [String: Any] else {
                return
            }

            self.nameTextField.text = userData["name"] as? String ?? ""
            self.surnameTextField.text = userData["surname"] as? String ?? ""
            self.emailTextField.text = Auth.auth().currentUser?.email ?? ""
            self.phoneNumberTextField.text = userData["phoneNumber"] as? String ?? ""
            self.dateOfBirthTextField.text = userData["dateOfBirth"] as? String ?? ""
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserData()
    }

    @objc func editButtonTapped(_ sender: UIButton) {
        nameTextField.isEnabled = true
        surnameTextField.isEnabled = true
        phoneNumberTextField.isEnabled = true
        dateOfBirthTextField.isEnabled = true

        editButton.isHidden = true
        saveButton.isHidden = false

        animateButton(sender)
    }

    @objc func saveButtonTapped(_ sender: UIButton) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        let userData: [String: Any] = [
            "name": nameTextField.text ?? "",
            "surname": surnameTextField.text ?? "",
            "email": emailTextField.text ?? "",
            "phoneNumber": phoneNumberTextField.text ?? "",
            "dateOfBirth": dateOfBirthTextField.text ?? ""
        ]

        let ref = Database.database().reference().child("users").child(userId)
        ref.setValue(userData) { (error, ref) in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
            } else {
                print("User data saved successfully")
                self.editButton.isHidden = false
                self.saveButton.isHidden = true

                self.nameTextField.isEnabled = false
                self.surnameTextField.isEnabled = false
                self.emailTextField.isEnabled = false
                self.phoneNumberTextField.isEnabled = false
                self.dateOfBirthTextField.isEnabled = false
            }
        }

        animateButton(sender)
    }

    @objc func deletedListingsButtonTapped(_ sender: UIButton) {
        let userListingsVC = DeleteUserTechItemViewController()
        navigationController?.pushViewController(userListingsVC, animated: true)
        animateButton(sender)
    }

    @objc func archivedListingsButtonTapped(_ sender: UIButton) {
        let archivedListingsVC = ArchiveUserTechItemViewController()
        navigationController?.pushViewController(archivedListingsVC, animated: true)
        animateButton(sender)
    }

    @objc func logoutButtonTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            let loginVC = LoginViewController()
            let navController = UINavigationController(rootViewController: loginVC)
            
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                window.rootViewController = navController
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
            }
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }

        animateButton(sender)
    }

    func animateButton(_ button: UIButton) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.1) {
                            button.transform = CGAffineTransform.identity
                        }
        })
    }
}
