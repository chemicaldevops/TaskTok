import Foundation

struct Task: Identifiable, Codable {
    let id: UUID
    var text: String
    var isCompleted: Bool = false
    
    var creationDate: Date = Date()
    
    var imageUrl: String?
    var link: String?
    var copyText: String?

    init(text: String, isCompleted: Bool = false, imageUrl: String? = nil, link: String? = nil, copyText: String? = nil, creationDate: Date = Date(), id: UUID = UUID()) {
        self.id = id
        self.text = text
        self.isCompleted = isCompleted
        self.imageUrl = imageUrl
        self.link = link
        self.copyText = copyText
        self.creationDate = creationDate
    }
}
