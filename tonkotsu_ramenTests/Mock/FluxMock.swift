
@testable import tonkotsu_ramen

extension Flux {
    static func mock(apiSession: MockQiitaApiRepository = .init(
        articles: Article.mockArticles()
    )) -> Flux {
        let articleDispatcher = ArticleDispatcher()
        
        let articleActionCreator = ArticleActionCreator(
            dispatcher: articleDispatcher,
            apiSession: apiSession
        )
        
        let articleStore = ArticleStore(
            dispatcher: articleDispatcher
        )

        return Flux(
            articleDispatcher: articleDispatcher,
            articleActionCreator: articleActionCreator,
            articleStore: articleStore
        )
    }
}
