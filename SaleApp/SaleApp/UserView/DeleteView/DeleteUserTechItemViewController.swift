

import UIKit
import Firebase
import SDWebImage

class DeleteUserTechItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var techItems: [TechItem] = []
    private let techDataManager = TechDataManager.shared
    private let tableView = UITableView()
    
    private lazy var noItemsLabel: UILabel = {
        let label = UILabel()
        label.text = "No tech items available"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "My Tech Items"
        view.backgroundColor = .white

        setupTableView()
        setupNoItemsLabel()
        fetchTechItems()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DeleteUserTechItemTableViewCell.self, forCellReuseIdentifier: "UserTechItemCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNoItemsLabel() {
        view.addSubview(noItemsLabel)
        NSLayoutConstraint.activate([
            noItemsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noItemsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func fetchTechItems() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User is not authenticated")
            return
        }
        
        techDataManager.databaseRef.child("techItems").queryOrdered(byChild: "userId").queryEqual(toValue: userId).observe(.value) { snapshot in
            var fetchedItems: [TechItem] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let techItemDict = snapshot.value as? [String: Any],
                   let techItem = self.dictionaryToTechItem(techItemDict) {
                    fetchedItems.append(techItem)
                }
            }
            // Filter items where status is 'deleteListing'
            self.techItems = fetchedItems.filter { $0.status == .deleteListing }
            self.noItemsLabel.isHidden = !self.techItems.isEmpty
            self.tableView.reloadData()
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

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return techItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTechItemCell", for: indexPath) as? DeleteUserTechItemTableViewCell else {
            return UITableViewCell()
        }

        let techItem = techItems[indexPath.row]
        cell.configure(with: techItem)
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let techItem = techItems[indexPath.row]
        let detailVC = UserTechDetailItemViewController()
        detailVC.techItem = techItem
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // Enable swipe to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let techItem = techItems[indexPath.row]
            techDataManager.deleteTechItem(byId: techItem.id) { error in
                if let error = error {
                    print("Failed to delete tech item: \(error)")
                } else {
                    print("Tech item deleted successfully")
                    self.techItems.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
}

// Custom UITableViewCell for displaying tech item information
class DeleteUserTechItemTableViewCell: UITableViewCell {
    private let photoImageView = UIImageView()
    private let categoryLabel = UILabel()
    private let brandLabel = UILabel()
    private let modelLabel = UILabel()
    private let priceLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.layer.cornerRadius = 8
        photoImageView.clipsToBounds = true

        categoryLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        brandLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        modelLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        priceLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        priceLabel.textColor = .systemGreen

        let textStackView = UIStackView(arrangedSubviews: [categoryLabel, brandLabel, modelLabel, priceLabel])
        textStackView.axis = .vertical
        textStackView.spacing = 8
        textStackView.alignment = .leading

        let containerStackView = UIStackView(arrangedSubviews: [photoImageView, textStackView])
        containerStackView.axis = .horizontal
        containerStackView.spacing = 12
        containerStackView.alignment = .center
        containerStackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(containerStackView)

        NSLayoutConstraint.activate([
            photoImageView.widthAnchor.constraint(equalTo: photoImageView.heightAnchor, multiplier: 1.4),
            photoImageView.heightAnchor.constraint(equalToConstant: 100),

            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func configure(with techItem: TechItem) {
        if let urlString = techItem.photos.first, let url = URL(string: urlString) {
            photoImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), completed: nil)
        } else {
            photoImageView.image = UIImage(named: "placeholder")
        }
        categoryLabel.text = techItem.category.rawValue
        brandLabel.text = "Brand: \(techItem.brand)"
        modelLabel.text = "Model: \(techItem.model)"
        priceLabel.text = "$\(techItem.price)"
    }
}
