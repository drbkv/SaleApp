import Foundation
import Firebase
import FirebaseStorage

class TechDataManager {
    static let shared = TechDataManager()
    private init() {}

    let storageRef = Storage.storage().reference()
    let databaseRef = Database.database().reference()

    func addTechItem(_ techItem: TechItem, completion: @escaping (Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "TechDataManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }

        let itemId = techItem.id
        var techItem = techItem
        techItem.userId = userId

        uploadPhotos(photos: techItem.photos, itemId: itemId) { urls, error in
            if let error = error {
                completion(error)
                return
            }

            guard let photoUrls = urls else {
                completion(NSError(domain: "TechDataManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to upload photos"]))
                return
            }

            var techItemDict = self.techItemToDictionary(techItem)
            techItemDict["photos"] = photoUrls

            self.databaseRef.child("techItems").child(itemId).setValue(techItemDict) { error, _ in
                completion(error)
            }
        }
    }

    func editTechItem(_ techItem: TechItem, completion: @escaping (Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid, techItem.userId == userId else {
            completion(NSError(domain: "TechDataManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authorized to edit this item"]))
            return
        }

        let itemId = techItem.id

        uploadPhotos(photos: techItem.photos, itemId: itemId) { urls, error in
            if let error = error {
                completion(error)
                return
            }

            guard let photoUrls = urls else {
                completion(NSError(domain: "TechDataManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to upload photos"]))
                return
            }

            var techItemDict = self.techItemToDictionary(techItem)
            techItemDict["photos"] = photoUrls

            self.databaseRef.child("techItems").child(itemId).updateChildValues(techItemDict) { error, _ in
                completion(error)
            }
        }
    }

    func deleteTechItem(byId itemId: String, completion: @escaping (Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "TechDataManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }

        self.databaseRef.child("techItems").child(itemId).observeSingleEvent(of: .value) { snapshot in
            guard let techItemDict = snapshot.value as? [String: Any], techItemDict["userId"] as? String == userId else {
                completion(NSError(domain: "TechDataManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authorized to delete this item"]))
                return
            }

            if let photoUrls = techItemDict["photos"] as? [String] {
                self.deletePhotos(urls: photoUrls) { error in
                    if let error = error {
                        completion(error)
                        return
                    }

                    self.databaseRef.child("techItems").child(itemId).removeValue { error, _ in
                        completion(error)
                    }
                }
            } else {
                self.databaseRef.child("techItems").child(itemId).removeValue { error, _ in
                    completion(error)
                }
            }
        }
    }

    private func uploadPhotos(photos: [String], itemId: String, completion: @escaping ([String]?, Error?) -> Void) {
        var photoUrls = [String]()
        let dispatchGroup = DispatchGroup()

        for (index, photoUrl) in photos.enumerated() {
            dispatchGroup.enter()
            let photoRef = storageRef.child("techItems/\(itemId)/photo\(index).jpg")
            guard let url = URL(string: photoUrl) else {
                dispatchGroup.leave()
                continue
            }

            // Asynchronous URLSession data task to fetch the image data
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(nil, error)
                    return
                }

                guard let data = data else {
                    dispatchGroup.leave()
                    return
                }

                photoRef.putData(data, metadata: nil) { metadata, error in
                    if let error = error {
                        completion(nil, error)
                        return
                    }

                    photoRef.downloadURL { url, error in
                        if let error = error {
                            completion(nil, error)
                            return
                        }

                        if let url = url {
                            photoUrls.append(url.absoluteString)
                        }

                        dispatchGroup.leave()
                    }
                }
            }.resume()
        }

        dispatchGroup.notify(queue: .main) {
            completion(photoUrls, nil)
        }
    }

    private func deletePhotos(urls: [String], completion: @escaping (Error?) -> Void) {
        let dispatchGroup = DispatchGroup()

        for url in urls {
            dispatchGroup.enter()
            let photoRef = storageRef.storage.reference(forURL: url)
            photoRef.delete { error in
                if let error = error {
                    completion(error)
                    return
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(nil)
        }
    }

    private func techItemToDictionary(_ techItem: TechItem) -> [String: Any] {
        return [
            "id": techItem.id,
            "userId": techItem.userId,
            "category": techItem.category.rawValue,
            "brand": techItem.brand,
            "model": techItem.model,
            "color": techItem.color,
            "price": techItem.price,
            "description": techItem.description,
            "status": techItem.status.rawValue,
            "photos": techItem.photos
        ]
    }
}
