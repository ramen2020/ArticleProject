//
//  ArticleViewModel.swift
//  tonkotsu_ramen
//
//  Created by 宮本光直 on 2021/06/14.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

protocol ArticleViewModelInputs {
    var searchWord: AnyObserver<String> { get }
}

protocol ArticleViewModelOutputs {
    var articles: Observable<[Article]> {get}
}

protocol ArticleViewModelType {
    var input: ArticleViewModelInputs {get}
    var output: ArticleViewModelOutputs {get}
}

class ArticleViewModel: ArticleViewModelInputs, ArticleViewModelOutputs {
    let searchWord: AnyObserver<String>
    let articles: Observable<[Article]>
    private let disposeBag = DisposeBag()
    private let provider = MoyaProvider<QiitaAPI>()
    
    init() {
        let _articles = PublishRelay<[Article]>()
        self.articles = _articles.asObservable()
        
        let _searchWord = PublishRelay<String>()
        self.searchWord = AnyObserver<String>() { event in
            guard let text = event.element else { return }
            
            _searchWord.accept(text)
        }

        _searchWord
            .debug("--------検索欄に入力しています------------")
            .debounce(RxTimeInterval(1), scheduler: MainScheduler())
//            .flatMapLatest { searchWord in
//                QiitaApiRepository.fetchQiitaArticlesBySearchWord(searchWord: searchWord)
//            }
            .flatMap { searchWord in
                QiitaApiRepository.fetchQiitaArticlesBySearchWord(searchWord: searchWord)
            }
            .debug("-----------記事取得しました-------------")
            .subscribe(onNext: { response in
                _articles.accept(response)
            })
            .disposed(by: disposeBag)

        
        QiitaApiRepository.fetchQiitaArticles()
            .subscribe(onNext: { response in
                _articles.accept(response)
            }).disposed(by: disposeBag)
    }
}

extension ArticleViewModel: ArticleViewModelType {
    var input: ArticleViewModelInputs {return self}
    var output: ArticleViewModelOutputs {return self}
}


