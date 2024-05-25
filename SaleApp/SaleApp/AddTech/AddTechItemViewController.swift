//
//  AddTechItemViewController.swift
//  SaleApp
//
//  Created by Ramzan on 24.05.2024.
//

import Foundation
import UIKit
import ImageSlideshow
import Firebase
import FirebaseStorage
import Hero

class AddTechItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {

    private let techDataManager = TechDataManager.shared
    private var userId: String?

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var slideshow: ImageSlideshow = {
        let slideshow = ImageSlideshow()
        slideshow.backgroundColor = .lightGray
        slideshow.contentScaleMode = .scaleAspectFill
        slideshow.clipsToBounds = true
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.slideshowInterval = 0
        slideshow.pageIndicator = UIPageControl()
        slideshow.hero.id = "slideshowHero"
        slideshow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openFullScreenSlideshow)))
        return slideshow
    }()

    private lazy var categorySegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Смартфоны", "Ноутбуки", "Планшеты", "Телевизоры", "Бытовая техника"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .white
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.layer.cornerRadius = 5
        segmentedControl.layer.borderColor = UIColor.lightGray.cgColor
        segmentedControl.layer.borderWidth = 1.0
        return segmentedControl
    }()

    private lazy var brandTextField: UITextField = {
        let textField = createTextField(placeholder: "Brand", keyboardType: .default, icon: "tag")
        return textField
    }()

    private lazy var modelTextField: UITextField = {
        let textField = createTextField(placeholder: "Model", keyboardType: .default, icon: "pencil")
        return textField
    }()

    private lazy var colorTextField: UITextField = {
        let textField = createTextField(placeholder: "Color", keyboardType: .default, icon: "paintbrush")
        return textField
    }()

    private lazy var priceTextField: UITextField = {
        let textField = createTextField(placeholder: "Price", keyboardType: .numberPad, icon: "dollarsign.circle")
        return textField
    }()

    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Description"
        textView.textColor = .lightGray
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5.0
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.inputAccessoryView = createToolbar()
        return textView
    }()

    private lazy var addPhotoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Photo", for: .normal)
        button.backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        return button
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Tech", for: .normal)
        button.backgroundColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(addTechItem), for: .touchUpInside)
        return button
    }()

    private var imageSources: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hero.isEnabled = true

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addArrangedSubview(slideshow)
        contentView.addArrangedSubview(categorySegmentedControl)
        contentView.addArrangedSubview(brandTextField)
        contentView.addArrangedSubview(modelTextField)
        contentView.addArrangedSubview(colorTextField)
        contentView.addArrangedSubview(priceTextField)
        contentView.addArrangedSubview(descriptionTextView)
        contentView.addArrangedSubview(addPhotoButton)
        contentView.addArrangedSubview(addButton)

        setupConstraints()

        if let uid = Auth.auth().currentUser?.uid {
            userId = uid
        }

        descriptionTextView.delegate = self
    }

    private func createTextField(placeholder: String, keyboardType: UIKeyboardType, icon: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
        textField.borderStyle = .roundedRect
        textField.leftView = UIImageView(image: UIImage(systemName: icon))
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1.0
        textField.inputAccessoryView = createToolbar()
        return textField
    }

    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([doneButton], animated: false)
        return toolbar
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            slideshow.heightAnchor.constraint(equalToConstant: 200),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    @objc private func addPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageSources.append(image)
            slideshow.setImageInputs(imageSources.map { ImageSource(image: $0) })
        }
        picker.dismiss(animated: true, completion: nil)
    }

    private func clearPhotos() {
        imageSources.removeAll()
        slideshow.setImageInputs([])
    }

    @objc private func addTechItem() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User ID not found")
            return
        }

        guard let brandText = brandTextField.text, !brandText.isEmpty,
              let modelText = modelTextField.text, !modelText.isEmpty,
              let colorText = colorTextField.text, !colorText.isEmpty,
              let priceText = priceTextField.text, !priceText.isEmpty,
              let descriptionText = descriptionTextView.text, !descriptionText.isEmpty, descriptionTextView.textColor != .lightGray else {
                  let alertController = UIAlertController(title: "Warning", message: "Please fill in all fields", preferredStyle: .alert)
                  alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                  present(alertController, animated: true, completion: nil)
                  return
        }

        guard !imageSources.isEmpty else {
            let alertController = UIAlertController(title: "Warning", message: "Please add at least one photo", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }

        var photoURLs: [String] = []
        let group = DispatchGroup()
        for image in imageSources {
            group.enter()
            let storageRef = Storage.storage().reference().child("techItems/\(UUID().uuidString).jpg")
            if let uploadData = image.jpegData(compressionQuality: 0.5) {
                storageRef.putData(uploadData, metadata: nil) { metadata, error in
                    if let error = error {
                        print("Error uploading photo: \(error.localizedDescription)")
                        group.leave() // Ensure the group leave is called
                    } else {
                        storageRef.downloadURL { url, error in
                            if let error = error {
                                print("Error getting download URL: \(error.localizedDescription)")
                            } else if let downloadURL = url?.absoluteString {
                                photoURLs.append(downloadURL)
                            }
                            group.leave()
                        }
                    }
                }
            } else {
                group.leave()
            }
        }

        group.notify(queue: .main) {
            guard let categoryTitle = self.categorySegmentedControl.titleForSegment(at: self.categorySegmentedControl.selectedSegmentIndex),
                  let category = Category(rawValue: categoryTitle) else {
                let alertController = UIAlertController(title: "Error", message: "Invalid category selected", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }

            let techItem = TechItem(
                id: UUID().uuidString,
                userId: userId,
                category: category,
                photos: photoURLs, // Pass the URLs instead of UIImage
                brand: brandText,
                model: modelText,
                color: colorText,
                price: Int(priceText) ?? 0,
                description: descriptionText,
                status: .inProgress // Default status
            )

            TechDataManager.shared.addTechItem(techItem) { error in
                if let error = error {
                    print("Error adding tech item: \(error.localizedDescription)")
                } else {
                    print("Tech item added successfully")
                    self.brandTextField.text = ""
                    self.modelTextField.text = ""
                    self.colorTextField.text = ""
                    self.priceTextField.text = ""
                    self.descriptionTextView.text = "Description"
                    self.descriptionTextView.textColor = .lightGray
                    self.clearPhotos()
                    let alertController = UIAlertController(title: "Success", message: "Tech item added successfully", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }

    @objc private func openFullScreenSlideshow() {
        let fullScreenController = FullScreenSlideshowViewController()
        fullScreenController.hero.isEnabled = true
        fullScreenController.hero.modalAnimationType = .fade
        fullScreenController.inputs = slideshow.images
        fullScreenController.transitioningDelegate = self
        fullScreenController.slideshow.hero.id = "slideshowHero"
        self.present(fullScreenController, animated: true, completion: nil)
    }
}

extension AddTechItemViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = .lightGray
        }
    }
}
