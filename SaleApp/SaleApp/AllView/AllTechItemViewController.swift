//import UIKit
//import Firebase
//import SDWebImage
//
//class AllTechItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    private var techItems: [TechItem] = []
//    private let techDataManager = TechDataManager.shared
//    private let tableView = UITableView()
//    
//    private lazy var noItemsLabel: UILabel = {
//        let label = UILabel()
//        label.text = "No tech items available"
//        label.textAlignment = .center
//        label.textColor = .gray
//        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
//        label.isHidden = true
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        title = "All Tech Items"
//        view.backgroundColor = .white
//
//        setupTableView()
//        setupNoItemsLabel()
//        setupNavigationBar()
//        fetchTechItems()
//    }
//
//    private func setupTableView() {
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(TechItemTableViewCell.self, forCellReuseIdentifier: "TechItemCell")
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(tableView)
//
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//    
//    private func setupNoItemsLabel() {
//        view.addSubview(noItemsLabel)
//        NSLayoutConstraint.activate([
//            noItemsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            noItemsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
//    
//    private func setupNavigationBar() {
//        let sortButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortButtonTapped))
//        sortButton.tintColor = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0) // Dark green color
//        navigationItem.rightBarButtonItem = sortButton
//    }
//
//    @objc private func sortButtonTapped() {
//        // Implement sorting functionality here
//        let alert = UIAlertController(title: "Sort", message: "Choose sorting option", preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "Price: Low to High", style: .default, handler: { _ in
//            self.sortTechItems(by: .priceAscending)
//        }))
//        alert.addAction(UIAlertAction(title: "Price: High to Low", style: .default, handler: { _ in
//            self.sortTechItems(by: .priceDescending)
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        present(alert, animated: true, completion: nil)
//    }
//
//    private enum SortOption {
//        case priceAscending
//        case priceDescending
//    }
//
//    private func sortTechItems(by option: SortOption) {
//        switch option {
//        case .priceAscending:
//            techItems.sort { $0.price < $1.price }
//        case .priceDescending:
//            techItems.sort { $0.price > $1.price }
//        }
//        tableView.reloadData()
//    }
//
//    private func fetchTechItems() {
//        techDataManager.databaseRef.child("techItems").observe(.value) { snapshot in
//            var fetchedItems: [TechItem] = []
//            for child in snapshot.children {
//                if let snapshot = child as? DataSnapshot,
//                   let techItemDict = snapshot.value as? [String: Any],
//                   let techItem = self.dictionaryToTechItem(techItemDict) {
//                    fetchedItems.append(techItem)
//                }
//            }
//            self.techItems = fetchedItems
//            self.noItemsLabel.isHidden = !fetchedItems.isEmpty
//            self.tableView.reloadData()
//        }
//    }
//
//    private func dictionaryToTechItem(_ dict: [String: Any]) -> TechItem? {
//        guard let id = dict["id"] as? String,
//              let userId = dict["userId"] as? String,
//              let categoryRaw = dict["category"] as? String,
//              let category = Category(rawValue: categoryRaw),
//              let photos = dict["photos"] as? [String],
//              let brand = dict["brand"] as? String,
//              let model = dict["model"] as? String,
//              let color = dict["color"] as? String,
//              let price = dict["price"] as? Int,
//              let description = dict["description"] as? String,
//              let statusRaw = dict["status"] as? String,
//              let status = Status(rawValue: statusRaw),
//              let telegramLink = dict["telegramLink"] as? String else {
//            return nil
//        }
//
//        return TechItem(
//            id: id,
//            userId: userId,
//            category: category,
//            photos: photos,
//            brand: brand,
//            model: model,
//            color: color,
//            price: price,
//            description: description,
//            status: status
//        )
//    }
//
//    // MARK: - UITableViewDataSource
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return techItems.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TechItemCell", for: indexPath) as? TechItemTableViewCell else {
//            return UITableViewCell()
//        }
//
//        let techItem = techItems[indexPath.row]
//        cell.configure(with: techItem)
//        return cell
//    }
//
//    // MARK: - UITableViewDelegate
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let techItem = techItems[indexPath.row]
//        let detailVC = AllTechDetailItemViewController()
//        detailVC.techItem = techItem
//        navigationController?.pushViewController(detailVC, animated: true)
//    }
//}
//
//// Custom UITableViewCell for displaying tech item information
//class TechItemTableViewCell: UITableViewCell {
//    private let photoImageView = UIImageView()
//    private let categoryLabel = UILabel()
//    private let brandLabel = UILabel()
//    private let modelLabel = UILabel()
//    private let priceLabel = UILabel()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupViews()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupViews() {
//        photoImageView.contentMode = .scaleAspectFit
//        photoImageView.layer.cornerRadius = 8
//        photoImageView.clipsToBounds = true
//
//        categoryLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
//        brandLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
//        modelLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
//        priceLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
//        priceLabel.textColor = .systemGreen
//
//        let textStackView = UIStackView(arrangedSubviews: [categoryLabel, brandLabel, modelLabel, priceLabel])
//        textStackView.axis = .vertical
//        textStackView.spacing = 8
//        textStackView.alignment = .leading
//
//        let containerStackView = UIStackView(arrangedSubviews: [photoImageView, textStackView])
//        containerStackView.axis = .horizontal
//        containerStackView.spacing = 12
//        containerStackView.alignment = .center
//        containerStackView.translatesAutoresizingMaskIntoConstraints = false
//
//        contentView.addSubview(containerStackView)
//
//        NSLayoutConstraint.activate([
//            photoImageView.widthAnchor.constraint(equalTo: photoImageView.heightAnchor, multiplier: 1.4),
//            photoImageView.heightAnchor.constraint(equalToConstant: 100),
//
//            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
//            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
//            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
//            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
//        ])
//    }
//
//    func configure(with techItem: TechItem) {
//        if let urlString = techItem.photos.first, let url = URL(string: urlString) {
//            photoImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), completed: nil)
//        } else {
//            photoImageView.image = UIImage(named: "placeholder")
//        }
//        categoryLabel.text = techItem.category.rawValue
//        brandLabel.text = "Brand: \(techItem.brand)"
//        modelLabel.text = "Model: \(techItem.model)"
//        priceLabel.text = "$\(techItem.price)"
//    }
//}
import UIKit
import Firebase
import SDWebImage

class AllTechItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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

        title = "All Tech Items"
        view.backgroundColor = .white

        setupTableView()
        setupNoItemsLabel()
        setupNavigationBar()
        observeTechItems()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TechItemTableViewCell.self, forCellReuseIdentifier: "TechItemCell")
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
    
    private func setupNavigationBar() {
        let sortButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortButtonTapped))
        sortButton.tintColor = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0) // Dark green color
        navigationItem.rightBarButtonItem = sortButton
    }

    @objc private func sortButtonTapped() {
        // Implement sorting functionality here
        let alert = UIAlertController(title: "Sort", message: "Choose sorting option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Price: Low to High", style: .default, handler: { _ in
            self.sortTechItems(by: .priceAscending)
        }))
        alert.addAction(UIAlertAction(title: "Price: High to Low", style: .default, handler: { _ in
            self.sortTechItems(by: .priceDescending)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private enum SortOption {
        case priceAscending
        case priceDescending
    }

    private func sortTechItems(by option: SortOption) {
        switch option {
        case .priceAscending:
            techItems.sort { $0.price < $1.price }
        case .priceDescending:
            techItems.sort { $0.price > $1.price }
        }
        tableView.reloadData()
    }

    private func observeTechItems() {
        techDataManager.databaseRef.child("techItems").observe(.value) { snapshot in
            var fetchedItems: [TechItem] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let techItemDict = snapshot.value as? [String: Any],
                   let techItem = self.dictionaryToTechItem(techItemDict) {
                    if techItem.status == .inProgress {
                        fetchedItems.append(techItem)
                    }
                }
            }
            self.techItems = fetchedItems
            self.noItemsLabel.isHidden = !fetchedItems.isEmpty
            self.tableView.reloadData()
        }
        
        techDataManager.databaseRef.child("techItems").observe(.childAdded) { snapshot in
            if let techItemDict = snapshot.value as? [String: Any],
               let techItem = self.dictionaryToTechItem(techItemDict) {
                if techItem.status == .inProgress {
                    self.techItems.append(techItem)
                    self.noItemsLabel.isHidden = !self.techItems.isEmpty
                    self.tableView.reloadData()
                }
            }
        }
        
        techDataManager.databaseRef.child("techItems").observe(.childChanged) { snapshot in
            if let techItemDict = snapshot.value as? [String: Any],
               let updatedTechItem = self.dictionaryToTechItem(techItemDict) {
                if let index = self.techItems.firstIndex(where: { $0.id == updatedTechItem.id }) {
                    self.techItems[index] = updatedTechItem
                    self.tableView.reloadData()
                }
            }
        }

        techDataManager.databaseRef.child("techItems").observe(.childRemoved) { snapshot in
            if let techItemDict = snapshot.value as? [String: Any],
               let removedTechItem = self.dictionaryToTechItem(techItemDict) {
                self.techItems.removeAll { $0.id == removedTechItem.id }
                self.noItemsLabel.isHidden = !self.techItems.isEmpty
                self.tableView.reloadData()
            }
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

        return TechItem(
            id: id,
            userId: userId,
            category: category,
            photos: photos,
            brand: brand,
            model: model,
            color: color,
            price: price,
            description: description,
            status: status
        )
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return techItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TechItemCell", for: indexPath) as? TechItemTableViewCell else {
            return UITableViewCell()
        }

        let techItem = techItems[indexPath.row]
        cell.configure(with: techItem)
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let techItem = techItems[indexPath.row]
        let detailVC = AllTechDetailItemViewController()
        detailVC.techItem = techItem
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// Custom UITableViewCell for displaying tech item information
class TechItemTableViewCell: UITableViewCell {
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
