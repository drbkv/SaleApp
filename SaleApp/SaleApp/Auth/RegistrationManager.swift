import Foundation
import Firebase

class RegistrationManager {
    static let shared = RegistrationManager()
    private init() {}
    
    func registerUser(email: String, password: String, name: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
            } else {
                guard let userId = authResult?.user.uid else {
                    completion(NSError(domain: "RegistrationManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID not found"]))
                    return
                }
                
                let userData = UserData(userId: userId, email: email, name: name, surname: "", dateOfBirth: "") // Устанавливаем роль "user"
                
                let databaseReference = Database.database().reference()
                var userDict = userData.toDictionary()
                userDict["userId"] = userId // Добавляем userId в словарь
                databaseReference.child("users").child(userId).setValue(userDict) { error, _ in
                    if let error = error {
                        completion(error)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
        
    }
    
}
