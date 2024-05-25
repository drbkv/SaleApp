import Foundation
import UIKit
import ImageSlideshow
import ImageSlideshowKingfisher
import Hero
import FirebaseAuth
import FirebaseDatabase

class UserTechDetailItemViewController: UIViewController {
    var techItem: TechItem?
    private var techItemRef: DatabaseReference?
    private var techItemHandle: DatabaseHandle?

    private lazy var slideshow: ImageSlideshow = {
        let slideshow = ImageSlideshow()
        slideshow.contentScaleMode = .scaleAspectFill
        slideshow.layer.cornerRadius = 10
        slideshow.clipsToBounds = true
        slideshow.hero.id = "image"
        slideshow.hero.modifiers = [.fade]
        return slideshow
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .leading
        return stackView
    }()
    
    private func createLabel(text: String, fontSize: CGFloat, isBold: Bool = false) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = isBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        label.numberOfLines = 0
        return label
    }
    
    private func createInfoView(iconName: String, text: String) -> UIView {
        let view = UIView()
        let iconImageView = UIImageView(image: UIImage(systemName: iconName))
        iconImageView.tintColor = .gray
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        let label = createLabel(text: text, fontSize: 20)
        
        view.addSubview(iconImageView)
        view.addSubview(label)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 28),
            iconImageView.heightAnchor.constraint(equalToConstant: 28),
            
            label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupUI()
        configureSlideshow()
        setupNavigationBar()
        
        if let techItem = techItem {
            observeTechItemChanges(itemId: techItem.id)
        }
    }
    
    deinit {
        removeTechItemObserver()
    }

    private func setupUI() {
        view.addSubview(slideshow)
        slideshow.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slideshow.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            slideshow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            slideshow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            slideshow.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35)
        ])

        view.addSubview(infoStackView)
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: slideshow.bottomAnchor, constant: 24),
            infoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func configureSlideshow() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        slideshow.addGestureRecognizer(tapGestureRecognizer)
    }

    private func populateTechItemDetails() {
        guard let techItem = techItem else { return }

        infoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let categoryView = createInfoView(iconName: "tag.fill", text: "Category: \(techItem.category.rawValue)")
        infoStackView.addArrangedSubview(categoryView)

        let brandView = createInfoView(iconName: "cart.fill", text: "Brand: \(techItem.brand)")
        infoStackView.addArrangedSubview(brandView)

        let modelView = createInfoView(iconName: "cube.box.fill", text: "Model: \(techItem.model)")
        infoStackView.addArrangedSubview(modelView)

        let colorView = createInfoView(iconName: "paintbrush.fill", text: "Color: \(techItem.color)")
        infoStackView.addArrangedSubview(colorView)

        let priceView = createInfoView(iconName: "dollarsign.circle.fill", text: "Price: \(techItem.price)")
        infoStackView.addArrangedSubview(priceView)

        let descriptionView = createInfoView(iconName: "text.alignleft", text: "Description: \(techItem.description)")
        infoStackView.addArrangedSubview(descriptionView)

        let statusView = createInfoView(iconName: "circle.fill", text: "Status: \(techItem.status.rawValue)")
        infoStackView.addArrangedSubview(statusView)

        let photoURLs = techItem.photos
        let kingfisherSources = photoURLs.compactMap { KingfisherSource(urlString: $0) }
        slideshow.setImageInputs(kingfisherSources)
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
    }

    @objc private func editButtonTapped() {
        guard let techItem = techItem else { return }
        let editVC = EditTechViewController()
        editVC.techItem = techItem
        navigationController?.pushViewController(editVC, animated: true)
    }

    @objc func imageTapped() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        fullScreenController.modalPresentationStyle = .fullScreen
        fullScreenController.hero.isEnabled = true
        fullScreenController.hero.modalAnimationType = .zoom
    }

    private func observeTechItemChanges(itemId: String) {
        techItemRef = Database.database().reference().child("techItems").child(itemId)
        techItemHandle = techItemRef?.observe(.value, with: { [weak self] snapshot in
            guard let self = self else { return }
            if let techItemDict = snapshot.value as? [String: Any],
               let updatedTechItem = self.dictionaryToTechItem(techItemDict) {
                self.techItem = updatedTechItem
                self.populateTechItemDetails()
            }
        })
    }

    private func removeTechItemObserver() {
        if let techItemHandle = techItemHandle {
            techItemRef?.removeObserver(withHandle: techItemHandle)
        }
    }

    private func dictionaryToTechItem(_ dict: [String: Any]) -> TechItem? {
        guard let id = dict["id"] as? String,
              let userId = dict["userId"] as? String,
              let categoryRaw = dict["category"] as? String,
              let category = Category(rawValue: categoryRaw),
              let photos = dict["photos"] as? [String],
              let brand = dict["brand"] as? String,
              let model = dict["model"] as? String,
              let color = dict["color"] as? String,
              let price = dict["price"] as? Int,
              let description = dict["description"] as? String,
              let statusRaw = dict["status"] as? String,
              let status = Status(rawValue: statusRaw) else {
            return nil
        }

        return TechItem(id: id, userId: userId, category: category, photos: photos, brand: brand, model: model, color: color, price: price, description: description, status: status)
    }
}
