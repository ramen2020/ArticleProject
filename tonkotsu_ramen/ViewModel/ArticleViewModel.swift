import Foundation
import RxSwift
import RxCocoa

protocol ArticleViewModelInputs {
    var searchWord: AnyObserver<String> {get}
    var searchCategoryButtonTapped: AnyObserver<SearchArticleCategoryButton> {get}
}

protocol ArticleViewModelOutputs {
    var articles: Observable<[Article]> {get}
    var isSelectedCategoryId: Observable<Int> {get}
    var isFetching: Observable<Bool> {get}
    var error: Observable<Error> {get}
}

protocol ArticleViewModelType {
    var input: ArticleViewModelInputs {get}
    var output: ArticleViewModelOutputs {get}
}

class ArticleViewModel: ArticleViewModelInputs, ArticleViewModelOutputs {
    
    // output
    var articles: Observable<[Article]>
    var isSelectedCategoryId: Observable<Int>
    var isFetching: Observable<Bool>
    var error: Observable<Error>
    
    // input
    var searchWord: AnyObserver<String>
    var searchCategoryButtonTapped: AnyObserver<SearchArticleCategoryButton>
    
    private let disposeBag = DisposeBag()
    
    init() {
        
        // output
        let _articles = PublishRelay<[Article]>()
        self.articles = _articles.asObservable()
        
        let _isSelectedCategoryId = PublishRelay<Int>()
        self.isSelectedCategoryId = _isSelectedCategoryId.asObservable()
        
        let _isFetching = PublishRelay<Bool>()
        self.isFetching = _isFetching.asObservable()
        
        let _error = PublishRelay<Error>()
        self.error = _error.asObservable()
        
        // input
        let _searchCategoryButtonTapped = PublishRelay<SearchArticleCategoryButton>()
        self.searchCategoryButtonTapped = AnyObserver<SearchArticleCategoryButton>() { event in
            guard let searchCategoryButton = event.element else {return}
            _isFetching.accept(true)
            _searchCategoryButtonTapped.accept(searchCategoryButton)
        }
        
        let _searchWord = PublishRelay<String>()
        self.searchWord = AnyObserver<String>() { event in
            guard let text = event.element else { return }
            _searchWord.accept(text)
        }
        
        let _ = QiitaApiRepository.fetchQiitaArticles()
            .materialize()
            .subscribe(onNext: { event in
                _isFetching.accept(false)
                switch event {
                case .next(let response):
                    _articles.accept(response)
                case .error(let error):
                    _error.accept(error)
                case .completed: break
                }
            }).disposed(by: disposeBag)
        
        let _ = _searchWord
            .debounce(RxTimeInterval(1), scheduler: MainScheduler())
            .flatMap { searchWord in
                QiitaApiRepository.fetchQiitaArticlesBySearchWord(searchWord: searchWord)
                    .materialize()
            }
            .subscribe(onNext: { event in
                switch event {
                case .next(let response):
                    _articles.accept(response)
                case .error(let error):
                    _error.accept(error)
                case .completed: break
                }
            }).disposed(by: disposeBag)
        
        let _ = _searchCategoryButtonTapped
            .flatMap {
                QiitaApiRepository.fetchQiitaArticlesByCategory(category: $0.name)
                    .materialize()
            }
            .subscribe(onNext: { event in
                _isFetching.accept(false)
                switch event {
                case .next(let response):
                    _articles.accept(response)
                case .error(let error):
                    _error.accept(error)
                case .completed: break
                }
            }).disposed(by: disposeBag)
    }
}

extension ArticleViewModel: ArticleViewModelType {
    var input: ArticleViewModelInputs {return self}
    var output: ArticleViewModelOutputs {return self}
}


