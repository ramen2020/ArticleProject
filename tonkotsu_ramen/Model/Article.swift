import Foundation

struct Article: Codable {
    let url: String
    let title: String
    let tags: [ArticleTags]
    let user: User
}

struct User: Codable {
    let name: String
    let profile_image_url: String
}

struct ArticleTags: Codable {
    let name: String
    let versions: [String]
}
