import RxCocoa
import RxSwift

final class ArticleActionCreator {

    static let shared = ArticleActionCreator()

    let fetchArticles: AnyObserver<Void>
    let fetchArticlesBySearchWord: AnyObserver<String>
    let fetchArticlesBySearchCategory: AnyObserver<String>
    
    private let dispatcher: ArticleDispatcher
    private let disposeBag = DisposeBag()

    init(
        dispatcher: ArticleDispatcher = .shared,
        apiSession: QiitaApiRepositoryProtocol = QiitaApiRepository.shared
    ) {
        self.dispatcher = dispatcher
        
        let _fetchArticles = PublishRelay<Void>()
        self.fetchArticles = AnyObserver<Void> { _ in
            _fetchArticles.accept(Void())
        }
        
        let _fetchArticlesBySearchWord = PublishRelay<String>()
        self.fetchArticlesBySearchWord = AnyObserver<String> { event in
            guard let element = event.element else {return}
            _fetchArticlesBySearchWord.accept(element)
        }
        
        let _fetchArticlesBySearchCategory = PublishRelay<String>()
        self.fetchArticlesBySearchCategory = AnyObserver<String> { event in
            guard let element = event.element else {return}
            _fetchArticlesBySearchCategory.accept(element)
        }

        _fetchArticles
            .flatMapLatest {
                apiSession.fetchQiitaArticles()
                    .materialize()
            }
            .subscribe(onNext: { event in
                switch event {
                case .next(let response):
                    dispatcher.articles.accept(response)
                case .error(let error):
                    dispatcher.error.accept(error)
                case .completed: break
                }
            }).disposed(by: disposeBag)
        
        _fetchArticlesBySearchWord
            .debounce(RxTimeInterval(1), scheduler: MainScheduler())
            .flatMap { searchWord in
                apiSession.fetchQiitaArticlesBySearchWord(searchWord: searchWord)
                    .materialize()
            }
            .subscribe(onNext: { event in
                switch event {
                case .next(let response):
                    print("::::::: response: ", response)
                    dispatcher.articles.accept(response)
                case .error(let error):
                    dispatcher.error.accept(error)
                case .completed: break
                }
            }).disposed(by: disposeBag)
        
        _fetchArticlesBySearchCategory
            .flatMapLatest {
                apiSession.fetchQiitaArticlesByCategory(category: $0)
                    .materialize()
            }
            .subscribe(onNext: { event in
                switch event {
                case .next(let response):
                    print("::::::: response: ", response)
                    dispatcher.articles.accept(response)
                case .error(let error):
                    dispatcher.error.accept(error)
                case .completed: break
                }
            }).disposed(by: disposeBag)
    }
}
