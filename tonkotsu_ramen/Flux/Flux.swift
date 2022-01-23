final class Flux {
    static let shared = Flux()

    let articleDispatcher: ArticleDispatcher
    let articleActionCreator: ArticleActionCreator
    let articleStore: ArticleStore

    init(articleDispatcher: ArticleDispatcher = .shared,
         articleActionCreator: ArticleActionCreator = .shared,
         articleStore: ArticleStore = .shared
    ) {
        self.articleDispatcher = articleDispatcher
        self.articleActionCreator = articleActionCreator
        self.articleStore = articleStore
    }
}
