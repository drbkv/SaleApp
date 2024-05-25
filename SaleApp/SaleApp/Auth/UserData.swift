class UserData {
    var userId: String
    let email: String
    let name: String
    let surname: String
    let dateOfBirth: String

    init(userId: String, email: String, name: String, surname: String, dateOfBirth: String) {
        self.userId = userId
        self.email = email
        self.name = name
        self.surname = surname
        self.dateOfBirth = dateOfBirth
    }

    func toDictionary() -> [String: Any] {
        return [
            "email": email,
            "name": name,
            "surname": surname,
            "dateOfBirth": dateOfBirth
        ]
    }
}
