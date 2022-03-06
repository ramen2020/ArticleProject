import Foundation
import RxCocoa
import RxSwift

protocol ArticleViewModelInputs {
    var featchArticles: AnyObserver<Void> {get}
    var searchWord: AnyObserver<String?> {get}
    var searchCategoryButtonTapped: AnyObserver<SearchArticleCategoryButton> {get}
}

protocol ArticleViewModelOutputs {
    var articles: Observable<[Article]> {get}
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
    var isFetching: Observable<Bool>
    var error: Observable<Error>
    
    // input
    var featchArticles: AnyObserver<Void>
    var searchWord: AnyObserver<String?>
    var searchCategoryButtonTapped: AnyObserver<SearchArticleCategoryButton>
    
    private let disposeBag = DisposeBag()
    
    init(flux: Flux) {
        
        let articleStore = flux.articleStore
        let articleActionCreator = flux.articleActionCreator
        
        // output
        let _articles = PublishRelay<[Article]>()
        self.articles = _articles.asObservable()
        
        let _isFetching = PublishRelay<Bool>()
        self.isFetching = _isFetching.asObservable()
        
        let _error = PublishRelay<Error>()
        self.error = _error.asObservable()
        
        // input
        self.featchArticles = AnyObserver<Void> { _ in
            articleActionCreator.fetchArticles.onNext(Void())
        }
        
        let _searchCategoryButtonTapped = PublishRelay<SearchArticleCategoryButton>()
        self.searchCategoryButtonTapped = AnyObserver<SearchArticleCategoryButton> { event in
            guard let searchCategoryButton = event.element else {return}
            _searchCategoryButtonTapped.accept(searchCategoryButton)
        }
        
        let _searchWord = PublishRelay<String?>()
        self.searchWord = AnyObserver<String?> { event in
            guard let text = event.element else { return }
            _searchWord.accept(text)
        }

        _searchWord
            .debounce(RxTimeInterval(1), scheduler: MainScheduler())
            .subscribe(onNext: { element in
                guard let element = element else {return}
                articleActionCreator.fetchArticlesBySearchWord.onNext(element)
            }).disposed(by: disposeBag)
        
        _searchCategoryButtonTapped
            .subscribe(onNext: { element in
                _isFetching.accept(true)
                articleActionCreator.fetchArticlesBySearchCategory.onNext(element.name)
            }).disposed(by: disposeBag)
        
        articleStore.articles
            .subscribe(onNext: { element in
                guard let element = element else {return}
                _isFetching.accept(false)
                _articles.accept(element)
            }).disposed(by: disposeBag)
        
        articleStore.error
            .subscribe(onNext: { element in
            _error.accept(element)
        }).disposed(by: disposeBag)
    }
}

extension ArticleViewModel: ArticleViewModelType {
    var input: ArticleViewModelInputs {return self}
    var output: ArticleViewModelOutputs {return self}
}
