final class Flux {
    static let shared = Flux()

    let articleDispatcher: ArticleDispatcher
    let articleActionCreator: ArticleActionCreator
    let articleStore: ArticleStore

    init(ArticleDispatcher: ArticleDispatcher = .shared,
         ArticleActionCreator: ArticleActionCreator = .shared,
         ArticleStore: ArticleStore = .shared
    ) {
        self.articleDispatcher = ArticleDispatcher
        self.articleActionCreator = ArticleActionCreator
        self.articleStore = ArticleStore
    }
}
