//
//
//import Foundation
//import UIKit
//import FirebaseAuth
//
//class EditTechViewController: UIViewController {
//    var techItem: TechItem?
//
//    private lazy var categoryPicker = createPicker()
//    private lazy var statusPicker = createPicker()
//    
//    private lazy var brandTextField = createTextField()
//    private lazy var modelTextField = createTextField()
//    private lazy var colorTextField = createTextField()
//    private lazy var priceTextField = createTextField()
//    private lazy var descriptionTextField = createTextField()
//    
//    private lazy var categoryTextField: UITextField = {
//        let textField = createTextField()
//        textField.inputView = categoryPicker
//        return textField
//    }()
//    
//    private lazy var statusTextField: UITextField = {
//        let textField = createTextField()
//        textField.inputView = statusPicker
//        return textField
//    }()
//
//    private func createTextField() -> UITextField {
//        let textField = UITextField()
//        textField.borderStyle = .roundedRect
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        return textField
//    }
//    
//    private func createPicker() -> UIPickerView {
//        let picker = UIPickerView()
//        picker.translatesAutoresizingMaskIntoConstraints = false
//        return picker
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupUI()
//        populateFields()
//        setupNavigationBar()
//        
//        categoryPicker.dataSource = self
//        categoryPicker.delegate = self
//        statusPicker.dataSource = self
//        statusPicker.delegate = self
//    }
//
//    private func setupUI() {
//        let stackView = UIStackView(arrangedSubviews: [
//            createLabelWithTextField("Category", textField: categoryTextField),
//            createLabelWithTextField("Brand", textField: brandTextField),
//            createLabelWithTextField("Model", textField: modelTextField),
//            createLabelWithTextField("Color", textField: colorTextField),
//            createLabelWithTextField("Price", textField: priceTextField),
//            createLabelWithTextField("Description", textField: descriptionTextField),
//            createLabelWithTextField("Status", textField: statusTextField)
//        ])
//        stackView.axis = .vertical
//        stackView.spacing = 20
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(stackView)
//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
//            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
//        ])
//    }
//
//    private func createLabelWithTextField(_ labelText: String, textField: UITextField) -> UIView {
//        let view = UIView()
//        let label = UILabel()
//        label.text = labelText
//        label.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(label)
//        view.addSubview(textField)
//        
//        NSLayoutConstraint.activate([
//            label.topAnchor.constraint(equalTo: view.topAnchor),
//            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            
//            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
//            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            textField.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//        
//        return view
//    }
//
//    private func populateFields() {
//        guard let techItem = techItem else { return }
//        
//        categoryTextField.text = techItem.category.rawValue
//        brandTextField.text = techItem.brand
//        modelTextField.text = techItem.model
//        colorTextField.text = techItem.color
//        priceTextField.text = "\(techItem.price)"
//        descriptionTextField.text = techItem.description
//        statusTextField.text = techItem.status.rawValue
//    }
//
//    private func setupNavigationBar() {
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
//    }
//
//    @objc private func saveButtonTapped() {
//        guard let techItem = techItem else { return }
//        guard let userId = Auth.auth().currentUser?.uid else {
//            print("User is not authenticated")
//            return
//        }
//
//        let updatedTechItem = TechItem(
//            id: techItem.id,
//            userId: userId,
//            category: Category(rawValue: categoryTextField.text ?? techItem.category.rawValue) ?? techItem.category,
//            photos: techItem.photos,
//            brand: brandTextField.text ?? techItem.brand,
//            model: modelTextField.text ?? techItem.model,
//            color: colorTextField.text ?? techItem.color,
//            price: Int(priceTextField.text ?? "\(techItem.price)") ?? techItem.price,
//            description: descriptionTextField.text ?? techItem.description,
//            status: Status(rawValue: statusTextField.text ?? techItem.status.rawValue) ?? techItem.status
//        )
//
//        TechDataManager.shared.editTechItem(updatedTechItem) { error in
//            if let error = error {
//                print("Failed to update tech item: \(error)")
//            } else {
//                self.showSuccessMessage()
//            }
//        }
//    }
//
//    private func showSuccessMessage() {
//        let alert = UIAlertController(title: "Success", message: "Data updated successfully", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
//            self.navigationController?.popViewController(animated: true)
//        })
//        present(alert, animated: true)
//    }
//}
//
//extension EditTechViewController: UIPickerViewDataSource, UIPickerViewDelegate {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if pickerView == categoryPicker {
//            return Category.allCases.count
//        } else {
//            return Status.allCases.count
//        }
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if pickerView == categoryPicker {
//            return Category.allCases[row].rawValue
//        } else {
//            return Status.allCases[row].rawValue
//        }
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if pickerView == categoryPicker {
//            categoryTextField.text = Category.allCases[row].rawValue
//        } else {
//            statusTextField.text = Status.allCases[row].rawValue
//        }
//    }
//}


import Foundation
import UIKit
import FirebaseAuth

class EditTechViewController: UIViewController {
    var techItem: TechItem?

    private lazy var categoryPicker = createPicker()
    private lazy var statusPicker = createPicker()
    
    private lazy var brandTextField = createTextField()
    private lazy var modelTextField = createTextField()
    private lazy var colorTextField = createTextField()
    private lazy var priceTextField = createTextField()
    private lazy var descriptionTextField = createTextField()
    
    private lazy var categoryTextField: UITextField = {
        let textField = createTextField()
        textField.inputView = categoryPicker
        return textField
    }()
    
    private lazy var statusTextField: UITextField = {
        let textField = createTextField()
        textField.inputView = statusPicker
        return textField
    }()

    private func createTextField() -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.inputAccessoryView = createToolbar()
        return textField
    }
    
    private func createPicker() -> UIPickerView {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }
    
    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([flexSpace, doneButton], animated: false)
        return toolbar
    }

    @objc private func doneButtonTapped() {
        view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        populateFields()
        setupNavigationBar()
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        statusPicker.dataSource = self
        statusPicker.delegate = self
    }

    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [
            createLabelWithTextField("Category", textField: categoryTextField),
            createLabelWithTextField("Brand", textField: brandTextField),
            createLabelWithTextField("Model", textField: modelTextField),
            createLabelWithTextField("Color", textField: colorTextField),
            createLabelWithTextField("Price", textField: priceTextField),
            createLabelWithTextField("Description", textField: descriptionTextField),
            createLabelWithTextField("Status", textField: statusTextField)
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func createLabelWithTextField(_ labelText: String, textField: UITextField) -> UIView {
        let view = UIView()
        let label = UILabel()
        label.text = labelText
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }

    private func populateFields() {
        guard let techItem = techItem else { return }
        
        categoryTextField.text = techItem.category.rawValue
        brandTextField.text = techItem.brand
        modelTextField.text = techItem.model
        colorTextField.text = techItem.color
        priceTextField.text = "\(techItem.price)"
        descriptionTextField.text = techItem.description
        statusTextField.text = techItem.status.rawValue
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
    }

    @objc private func saveButtonTapped() {
        guard let techItem = techItem else { return }
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User is not authenticated")
            return
        }

        let updatedTechItem = TechItem(
            id: techItem.id,
            userId: userId,
            category: Category(rawValue: categoryTextField.text ?? techItem.category.rawValue) ?? techItem.category,
            photos: techItem.photos,
            brand: brandTextField.text ?? techItem.brand,
            model: modelTextField.text ?? techItem.model,
            color: colorTextField.text ?? techItem.color,
            price: Int(priceTextField.text ?? "\(techItem.price)") ?? techItem.price,
            description: descriptionTextField.text ?? techItem.description,
            status: Status(rawValue: statusTextField.text ?? techItem.status.rawValue) ?? techItem.status
        )

        TechDataManager.shared.editTechItem(updatedTechItem) { error in
            if let error = error {
                print("Failed to update tech item: \(error)")
            } else {
                self.showSuccessMessage()
            }
        }
    }

    private func showSuccessMessage() {
        let alert = UIAlertController(title: "Success", message: "Data updated successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}

extension EditTechViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPicker {
            return Category.allCases.count
        } else {
            return Status.allCases.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPicker {
            return Category.allCases[row].rawValue
        } else {
            return Status.allCases[row].rawValue
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPicker {
            categoryTextField.text = Category.allCases[row].rawValue
        } else {
            statusTextField.text = Status.allCases[row].rawValue
        }
    }
}
