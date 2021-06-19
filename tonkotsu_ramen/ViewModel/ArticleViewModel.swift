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
            _isFetching.accept(true)
            _searchWord.accept(text)
        }
        
        let _ = QiitaApiRepository.fetchQiitaArticles()
            .subscribe(onNext: { response in
                _isFetching.accept(false)
                _articles.accept(response)
            }).disposed(by: disposeBag)
        
        let _ = _searchWord
            .debounce(RxTimeInterval(1), scheduler: MainScheduler())
            .flatMap { searchWord in
                QiitaApiRepository.fetchQiitaArticlesBySearchWord(searchWord: searchWord)
            }
            .subscribe(onNext: { response in
                _isFetching.accept(false)
                _articles.accept(response)
            })
            .disposed(by: disposeBag)
        
        let _ = _searchCategoryButtonTapped
            .flatMap {
                QiitaApiRepository.fetchQiitaArticlesByCategory(category: $0.name)
            }
            .subscribe({event in
                guard let articles = event.element else {return}
                _isFetching.accept(false)
                _articles.accept(articles)
            }).disposed(by: disposeBag)
    }
}

extension ArticleViewModel: ArticleViewModelType {
    var input: ArticleViewModelInputs {return self}
    var output: ArticleViewModelOutputs {return self}
}


