import Foundation
import RxCocoa
import RxSwift

final class ArticleStore {
    static let shared = ArticleStore()

    var articles: Observable<[Article]?> {
        return _articles.asObservable()
    }
    private let _articles = BehaviorRelay<[Article]?>(value: nil)

    var error: Observable<Error> {
        return _error.asObservable()
    }
    private let _error = PublishRelay<Error>()

    private let disposeBag = DisposeBag()

    init(dispatcher: ArticleDispatcher = .shared) {
        dispatcher.articles
            .bind(to: _articles)
            .disposed(by: disposeBag)
        
        dispatcher.error
            .bind(to: _error)
            .disposed(by: disposeBag)
    }
}
