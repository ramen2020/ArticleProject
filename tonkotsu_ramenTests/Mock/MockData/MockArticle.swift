
import Foundation
@testable import tonkotsu_ramen

extension Article {
    
    static func mockArticles() -> [Article] {
        return [.mockArticle(), .mockArticle2(), .mockArticle3(), .mockArticleFlutter()]
    }
    
    static func mockArticle() -> Article {
        return Article(
            url: "https://qiita.com/official-events",
            title: "初学者向けの情報",
            tags: [
                ArticleTags(
                    name: "Swift",
                    versions: []
                )
            ],
            user: User(
                name: "宮本",
                profile_image_url: "https://avatars.githubusercontent.com/u/73060251?v=4"
            )
        )
    }
    
    static func mockArticle2() -> Article {
        return Article(
            url: "https://qiita.com/question-trend",
            title: "Cloud Functionsのコマンド",
            tags: [
                ArticleTags(
                    name: "Python",
                    versions: []
                ),
                ArticleTags(
                    name: "batch",
                    versions: []
                ),
                ArticleTags(
                    name: "GoogleCloudPlatform",
                    versions: []
                ),
                ArticleTags(
                    name: "gcloud",
                    versions: []
                ),
                ArticleTags(
                    name: "GoogleCloudFunctions",
                    versions: []
                )
            ],
            user: User(
                name: "おはよう",
                profile_image_url: "https://s3-ap-northeast-1.amazonaws.com/qiita-image-store/0/1984110/bff48e603e1c7ee8b0ccedde3c40f6baef776f42/x_large.png?1646548039")
        )
    }
    
    static func mockArticle3() -> Article {
        return Article(
            url: "https://qiita.com/trend",
            title: "プログラミングRuby",
            tags: [
                ArticleTags(
                    name: "Ruby",
                    versions: []
                ),
                ArticleTags(
                    name: "Rails",
                    versions: []
                )
            ],
            user: User(
                name: "おやすみ",
                profile_image_url: "https://s3-ap-northeast-1.amazonaws.com/qiita-image-store/0/2485775/a0eebac0e206e10a8ce6f0d7730b8066e93a5b72/large.png?1643560932")
        )
    }
    
    static func mockArticleFlutter() -> Article {
        return Article(
            url: "https://qiita.com/wangqijiangjun/items/8ce5307da74d67212f03",
            title: "メタプログラミングRuby オブジェクトモデル",
            tags: [
                ArticleTags(
                    name: "Flutter",
                    versions: []
                ),
                ArticleTags(
                    name: "初心者",
                    versions: []
                )
            ],
            user: User(
                name: "こんにちわ",
                profile_image_url: "https://s3-ap-northeast-1.amazonaws.com/qiita-image-store/0/2485775/a0eebac0e206e10a8ce6f0d7730b8066e93a5b72/large.png?1643560932")
        )
    }
}
